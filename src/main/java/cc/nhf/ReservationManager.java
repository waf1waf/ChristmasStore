package cc.nhf;

import org.apache.log4j.Logger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

import static cc.nhf.DatabaseUtil.getDataSource;

public class ReservationManager extends ObjectManager {
    private final Logger logger = Logger.getLogger(this.getClass());
    private static final String UPDATE_RESERVATION_COUNT = "UPDATE reservation SET count=? WHERE id=?";
    private static final String DELETE_RESERVATION = "DELETE FROM reservation WHERE id=?";
    private static final String DELETE_RESERVATIONS_FOR_VOLUNTEER = "DELETE FROM reservation WHERE fk_volunteer_id=?";
    private static final String ADD_RESERVATION = "INSERT INTO reservation (fk_volunteer_id, fk_shift_id, fk_area_id, count) VALUES (?,?,?,?)";
    private static final String SELECT_ALL = "SELECT id, fk_volunteer_id, fk_area_id, fk_shift_id, count FROM reservation";

    private static ReservationManager uniqueInstance = null;

    private static final VolunteerManager volunteerManager = VolunteerManager.getInstance();

    private static ArrayList<Reservation> reservationList;

    public static synchronized ReservationManager getInstance() {
        if (ReservationManager.uniqueInstance == null) {
            ReservationManager.uniqueInstance = new ReservationManager();
        }
        return ReservationManager.uniqueInstance;
    }

    @Override
    protected ReservationManager clone() throws CloneNotSupportedException {
        throw new CloneNotSupportedException("Cloning of singleton is not supported");
    }

    private ReservationManager() {
    }

    public synchronized ArrayList<Reservation> getReservations() {
        if (reservationList == null) {
            reservationList = new ArrayList<>();
            try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
                 Statement statement = connection.createStatement();
                 ResultSet resultSet = statement.executeQuery(SELECT_ALL)) {
                while (resultSet.next()) {
                    reservationList.add(new Reservation(resultSet.getInt(1),
                            resultSet.getInt(2), resultSet.getInt(3),
                            resultSet.getInt(4), resultSet.getInt(5)));
                }
            } catch (Exception e) {
                logger.error(e.getLocalizedMessage());
            }
        }
        Collections.sort(reservationList);
        return reservationList;
    }

    public ArrayList<Reservation> getReservationsByVolunteer(int volunteerId) {
        ArrayList<Reservation> reservations = new ArrayList<>();
        for (Reservation reservation : getReservations()) {
            if (reservation.getVolunteer().getId() == volunteerId) {
                reservations.add(reservation);
            }
        }
        return reservations;
    }

    void deleteReservationsForVolunteer(int volunteerId) {
        List<Reservation> reservations = getReservationsByVolunteer(volunteerId);
        reservationList.removeAll(reservations);
        try (Connection connection = Objects.requireNonNull(Objects.requireNonNull(getDataSource()).getConnection());
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_RESERVATIONS_FOR_VOLUNTEER)) {

            preparedStatement.setInt(1, volunteerId);
            preparedStatement.executeUpdate();

        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());
        }
    }

    private ArrayList<Reservation> getReservationsByAreaAndShift(int areaId, int shiftId) {
        ArrayList<Reservation> reservations = new ArrayList<>();
        for (Reservation reservation : getReservations()) {
            if (reservation.getArea().getId() == areaId && reservation.getShift().getId() == shiftId) {
                reservations.add(reservation);
            }
        }
        return reservations;
    }

    public ArrayList<Reservation> getReservationsByAreaAndShift(Area area, Shift shift) {
        return getReservationsByAreaAndShift(area.getId(), shift.getId());
    }

    public int getCountByAreaAndShift(int areaId, int shiftId) {
        int count = 0;
        for (Reservation reservation : getReservations()) {
            if (reservation.getArea().getId() == areaId && reservation.getShift().getId() == shiftId) {
                count += reservation.getCount();
            }
        }
        return count;
    }

    public int getCountByAreaAndShift(Area area, Shift shift) {
        return getCountByAreaAndShift(area.getId(), shift.getId());
    }

    private Reservation getReservation(int id) {
        for (Reservation reservation : getReservations()) {
            if (reservation.getId() == id) {
                return reservation;
            }
        }
        return null;
    }

    public void addReservation(int volunteerId, int areaId, int shiftId, int count) {
        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(ADD_RESERVATION, Statement.RETURN_GENERATED_KEYS)) {

            preparedStatement.setInt(1, volunteerId);
            preparedStatement.setInt(2, shiftId);
            preparedStatement.setInt(3, areaId);
            preparedStatement.setInt(4, count);

            preparedStatement.executeUpdate();

            ResultSet resultSet = preparedStatement.getGeneratedKeys();
            resultSet.next();
            int id = resultSet.getInt(1);
            reservationList.add(new Reservation(id, volunteerId, areaId, shiftId, count));

        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());
        }
    }

    public synchronized void deleteReservation(int reservationId) {
        Reservation reservation = getReservation(reservationId);
        Volunteer volunteer = Objects.requireNonNull(reservation).getVolunteer();
        deleteObject(DELETE_RESERVATION, reservationId);
        reservationList.removeIf(x -> x.getId() == reservationId);
    }

    public synchronized void updateReservationCount(Reservation reservation, int count) {
        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_RESERVATION_COUNT)) {

            preparedStatement.setInt(1, count);
            preparedStatement.setInt(2, reservation.getId());
            preparedStatement.executeUpdate();

        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());
        }

        reservation.setCount(count);
    }

    int getReservationCountByVolunteer(Volunteer volunteer) {
        return getReservationsByVolunteer(volunteer.getId()).size();
    }
}
