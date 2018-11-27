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

public class ShiftManager extends ObjectManager {
    private final Logger logger = Logger.getLogger(this.getClass());
    private static final String UPDATE_SHIFT = "UPDATE shift SET pos=?, name=? WHERE id=?";
    private static final String INSERT_SHIFT = "INSERT INTO shift (pos,name) VALUES (?,?)";
    private static final String SELECT_FROM_SHIFT_ORDER_BY_POS = "SELECT id, pos, name FROM shift ORDER BY pos";
    private static final String DELETE_SHIFT = "DELETE FROM shift WHERE id=?";

    private static ShiftManager uniqueInstance = null;

    private static ArrayList<Shift> shifts = null;

    public static synchronized ShiftManager getInstance() {
        if (ShiftManager.uniqueInstance == null)
            ShiftManager.uniqueInstance = new ShiftManager();
        return ShiftManager.uniqueInstance;
    }

    @Override
    protected ShiftManager clone() throws CloneNotSupportedException {
        throw new CloneNotSupportedException("Cloning of singleton not supported");
    }

    private ShiftManager() {}

    public synchronized ArrayList<Shift> getShifts() {
        if (shifts == null) {
            shifts = new ArrayList<>();
            try (Statement statement = Objects.requireNonNull(getDataSource()).getConnection().createStatement();
                 ResultSet resultSet = statement.executeQuery(SELECT_FROM_SHIFT_ORDER_BY_POS)) {

                while (resultSet.next()) {
                    Shift shift = new Shift();
                    shift.setId(resultSet.getInt("id"));
                    shift.setPos(resultSet.getInt("pos"));
                    shift.setName(resultSet.getString("name"));
                    shifts.add(shift);
                }

            } catch (Exception e) {
                logger.error(e.getLocalizedMessage());
            }
            Collections.sort(shifts);
        }
        return shifts;
    }

    public Shift getShift(int id) {
        for (Shift shift : getShifts()) {
            if (shift.getId() == id) {
                return shift;
            }
        }
        return null;
    }

    private Shift getShiftByPos(int pos) {
        for (Shift shift : getShifts()) {
            if (shift.getPos() == pos) {
                return shift;
            }
        }
        return null;
    }

    public void moveUp(int shiftId) {
        Shift shift = getShift(shiftId);
        int pos = shift.getPos();
        if (pos != 1) {
            Shift swapShift = getShiftByPos(pos - 1);
            if (swapShift != null) {
                swapShift.setPos(pos);
            }
            updateShift(swapShift);
            shift.setPos(pos - 1);
            updateShift(shift);
        }
        Collections.sort(shifts);
    }

    public void moveDown(int id) {
        Shift shift = getShift(id);
        int pos = shift.getPos();
        if (shift.getPos() != shifts.size()) {
            Shift swapShift = getShiftByPos(pos + 1);
            if (swapShift != null) {
                swapShift.setPos(pos);
            }
            updateShift(swapShift);
            shift.setPos(pos + 1);
            updateShift(shift);
        }
        Collections.sort(shifts);
    }

    public synchronized void addShift(Shift shift) {
        ArrayList<Shift> shifts = getShifts();
        int pos = shifts.size() + 1;
        String name = shift.getName();

        // Update the database copy
        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_SHIFT)) {

            preparedStatement.setInt(1, pos);
            preparedStatement.setString(2, name);
            preparedStatement.executeUpdate();

        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());
        }
    }

    public synchronized void updateShift(Shift shift) {
        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_SHIFT)) {

            preparedStatement.setInt(1, shift.getPos());
            preparedStatement.setString(2, shift.getName());
            preparedStatement.setInt(3, shift.getId());
            preparedStatement.executeUpdate();

        } catch (Exception exception) {
            logger.error(exception.getLocalizedMessage());
        }
    }

    public void deleteShift(int shiftId) {
        shifts.remove(getShift(shiftId));
        deleteObject(DELETE_SHIFT, shiftId);
    }
}
