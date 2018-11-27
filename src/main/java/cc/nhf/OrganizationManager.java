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

public class OrganizationManager extends ObjectManager {
    private static final Logger logger = Logger.getLogger("OrganizationManager");
    private static final String DELETE_ORGANIZATION = "DELETE FROM organization WHERE id=?";
    private static final String GET_ORGANIZATIONS = "SELECT id, name FROM organization ORDER BY name";
    private static final String SET_NAME = "UPDATE organization SET name=? WHERE id=?";
    private static final String ADD_ORGANIZATION = "INSERT INTO organization (name) VALUES (?)";

    private static OrganizationManager uniqueInstance = null;

    private ArrayList<Organization> organizations;

    public static synchronized OrganizationManager getInstance() {
        if (OrganizationManager.uniqueInstance == null) {
            OrganizationManager.uniqueInstance = new OrganizationManager();
        }
        return OrganizationManager.uniqueInstance;
    }

    @Override
    protected OrganizationManager clone() throws CloneNotSupportedException {
        throw new CloneNotSupportedException("Cloning of singleton not supported");
    }

    private OrganizationManager() {
        getOrganizations();
    }

    public synchronized ArrayList<Organization> getOrganizations() {
        if (organizations == null) {
            organizations = new ArrayList<>();
            try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
                 Statement statement = connection.createStatement();
                 ResultSet resultSet = statement.executeQuery(GET_ORGANIZATIONS)) {

                while (resultSet.next()) {
                    organizations.add(new Organization(resultSet.getInt("id"),
                            resultSet.getString("name")));
                }
            } catch (Exception e) {
                logger.error(e.getLocalizedMessage());
            }
        }

        Collections.sort(organizations);
        return organizations;
    }

    public Organization getOrganization(int organizationId) {
        for (Organization organization : organizations) {
            if (organization.getId() == organizationId) {
                return organization;
            }
        }
        return null;
    }

    public synchronized void updateOrganization(int id, String name) {
        // Update the database copy
        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SET_NAME)) {

            preparedStatement.setString(1, name);
            preparedStatement.setInt(2, id);
            preparedStatement.executeUpdate();

            getOrganization(id).setName(name);

        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());
        }
    }

    public synchronized void addOrganization(String name) {
        // Add the new Organization to the database
        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(ADD_ORGANIZATION, Statement.RETURN_GENERATED_KEYS)
        ) {

            preparedStatement.setString(1, name);
            preparedStatement.executeUpdate();
            ResultSet resultSet = preparedStatement.getGeneratedKeys();
            resultSet.next();
            organizations.add(new Organization(resultSet.getInt(1), name));

        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());
        }
    }

    public Organization findOrganizationByName(String name) {
        for (Organization organization : getOrganizations()) {
            if (organization.getName().equals(name)) {
                return organization;
            }
        }
        return null;
    }

    public synchronized void deleteOrganization(int id) {
        organizations.removeIf(organization -> organization.getId() == id);
        deleteObject(DELETE_ORGANIZATION, id);
    }
}
