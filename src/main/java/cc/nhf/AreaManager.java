package cc.nhf;

import org.apache.log4j.Logger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Objects;

import static cc.nhf.DatabaseUtil.getDataSource;

public class AreaManager {
    private static final String SELECT_AREAS = "SELECT id, name, description, minimum_age FROM area ORDER BY name";
    private static final String UPDATE_AREA = "UPDATE area SET name=?, description=?, minimum_age=? WHERE id=?";
    private static final String ADD_AREA = "INSERT INTO area (name, description, minimum_age) VALUES (?,?,?)";
    private static final String SELECT_BY_NAME = "SELECT * FROM area WHERE name = ?";
    private static final String DELETE_FROM_AREA_BY_ID = "DELETE FROM area WHERE id=?";
    private final Logger logger = Logger.getLogger(this.getClass());

    private static AreaManager uniqueInstance = null;
    private static ArrayList<Area> areas;

    public static synchronized AreaManager getInstance() {
        if (AreaManager.uniqueInstance == null) {
            AreaManager.uniqueInstance = new AreaManager();
        }
        return AreaManager.uniqueInstance;
    }

    @Override
    protected AreaManager clone() throws CloneNotSupportedException {
        throw new CloneNotSupportedException("Cloning of singleton not supported");
    }

    private AreaManager() {}

    public synchronized ArrayList<Area> getAreas() {
        if (areas == null) {
            try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
                 Statement statement = connection.createStatement();
                 ResultSet resultSet = statement.executeQuery(SELECT_AREAS)) {

                areas = new ArrayList<>();
                while (resultSet.next()) {
                    Area area = new Area();
                    area.setId(resultSet.getInt("id"));
                    area.setName(resultSet.getString("name"));
                    area.setDescription(resultSet.getString("description"));
                    area.setMinimumAge(Integer.parseInt(resultSet.getString("minimum_age")));
                    areas.add(area);
                }
            } catch (Exception e) {
                logger.error(e.getLocalizedMessage());
            }
        }

        Collections.sort(areas);
        return areas;
}

    public Area getAreaById(int id) {
        for (Area area : getAreas()) {
            if (area.getId() == id) {
                return area;
            }
        }
        return null;
    }

    public synchronized void updateArea(int id, String name, String description, int minimumAge) {
        // Update the local copy
        Area a = this.getAreaById(id);
        a.setName(name);
        a.setDescription(description);
        a.setMinimumAge(minimumAge);

		/* Update the database copy */
        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_AREA)) {

            preparedStatement.setString(1, name);
            preparedStatement.setString(2, description);
            preparedStatement.setInt(3, minimumAge);
            preparedStatement.setInt(4, id);
            preparedStatement.executeUpdate();

        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());
        }
    }

    public synchronized void addArea(String name, String description, int minimumAge) {
        // Don't allow another with the same name
        Area area = findAreaByName(name);
        if (area != null) {
            return;
        }

        // Add the new Area to the database
        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(ADD_AREA)) {

            preparedStatement.setString(1, name);
            preparedStatement.setString(2, description);
            preparedStatement.setInt(3, minimumAge);
            preparedStatement.executeUpdate();

        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());
        }

        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_BY_NAME)) {

            preparedStatement.setString(1, name);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                resultSet.next();

                // Update the local copy
                Area a = new Area();
                a.setId(resultSet.getInt("id"));
                a.setName(resultSet.getString("name"));
                a.setDescription(resultSet.getString("description"));
                a.setMinimumAge(resultSet.getInt("minimum_age"));
                areas.add(a);
            } catch (Exception e) {
                logger.error(e.getLocalizedMessage());
            }
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage(), e);
        }
        Collections.sort(areas);
    }

    private Area findAreaByName(String name) {
        for (Area area : getAreas()) {
            if (area.getName().equals(name)) {
                return area;
            }
        }
        return null;
    }

    public synchronized void deleteArea(int id) {
        // Delete database copy
        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(DELETE_FROM_AREA_BY_ID)) {
            preparedStatement.setInt(1, id);

            preparedStatement.executeUpdate();
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());

            //  Delete local copy
            areas.remove(getAreaById(id));
        }
    }
}