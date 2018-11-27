package cc.nhf;

import org.apache.log4j.Logger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import static cc.nhf.DatabaseUtil.getDataSource;

public class NeedManager {
    private static final String SET_COUNT = "UPDATE need SET count=? WHERE fk_area_id=? AND fk_shift_id=?";
    private static final String ADD_NEED = "INSERT INTO need (fk_area_id, fk_shift_id, count) VALUES (?,?,?) ON DUPLICATE KEY UPDATE count = count";
    private static final String GET_ALL = "SELECT fk_area_id, fk_shift_id, count FROM need";
    private static final Logger logger = Logger.getLogger("NeedManager");

    private static final Map<String, Need> needMap = new HashMap<>();

    private static NeedManager uniqueInstance = null;

    private static final ReservationManager reservationManager = ReservationManager.getInstance();
    private static final AreaManager areas = AreaManager.getInstance();
    private static final ShiftManager shiftManager = ShiftManager.getInstance();

    public static synchronized NeedManager getInstance() {
        if (NeedManager.uniqueInstance == null) {
            NeedManager.uniqueInstance = new NeedManager();
        }
        return NeedManager.uniqueInstance;
    }

    @Override
    protected NeedManager clone() throws CloneNotSupportedException {
        throw new CloneNotSupportedException("Cloning of singleton not supported");
    }

    private NeedManager() {
        loadNeedMap();
    }

    private void loadNeedMap() {
        needMap.clear();
        try (Statement statement = Objects.requireNonNull(getDataSource()).getConnection().createStatement();
             ResultSet resultSet = statement.executeQuery(GET_ALL)) {
            while (resultSet.next()) {
                int areaId = resultSet.getInt(1);
                int shiftId = resultSet.getInt(2);
                int count = resultSet.getInt(3);
                Need need = new Need(areaId, shiftId, count);
                needMap.put(makeKey(areaId, shiftId), need);
            }
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());
        }
    }

    public void addNeed(int areaId, int shiftId, int count) {
        updateDatabase(ADD_NEED, areaId, shiftId, count);
    }

    public void setCount(int areaId, int shiftId, int count) {
        updateDatabase(SET_COUNT, count, areaId, shiftId);
        needMap.get(makeKey(areaId, shiftId)).setCount(count);
    }

    private void updateDatabase(String sqlStatement, int areaId, int shiftId, int count) {
        try (Connection connection = Objects.requireNonNull(DatabaseUtil.getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sqlStatement)) {

            preparedStatement.setInt(1, areaId);
            preparedStatement.setInt(2, shiftId);
            preparedStatement.setInt(3, count);

            preparedStatement.executeUpdate();

            Need need = new Need(areaId, shiftId, count);
            needMap.put(makeKey(areaId, shiftId), need);
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());
        }
    }

    private static String makeKey(int areaId, int shiftId) {
        return areaId + "-" + shiftId;
    }

    public Need getNeed(int areaId, int shiftId) {
        return needMap.get(makeKey(areaId, shiftId));
    }

    public int getCount(int areaId, int shiftId) {
        return getNeed(areaId, shiftId).getCount();
    }

    public int stillNeed(int areaId, int shiftId) {
        return Math.max(getCount(areaId, shiftId) - reservationManager.getCountByAreaAndShift(areaId, shiftId), 0);
    }

    public int maxStillNeedByArea(int areaId) {
        int need = 0;
        for (Shift shift : shiftManager.getShifts()) {
            if (stillNeed(areaId, shift.getId()) > need) {
                need = stillNeed(areaId, shift.getId());
            }
        }
        return need;
    }

    public int maxStillNeedByShift(int shiftId) {
        int need = 0;
        for (Area area : areas.getAreas()) {
            if (stillNeed(area.getId(), shiftId) > need) {
                need = stillNeed(area.getId(), shiftId);
            }
        }
        return need;
    }
}
