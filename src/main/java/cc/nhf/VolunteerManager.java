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

public class VolunteerManager extends ObjectManager {
    private static final Logger logger = Logger.getLogger("Volunteer");
    private static final String SELECT_ALL_VOLUNTEERS = "SELECT id, first_name, last_name, email_address, phone_number, other_organization, fk_organization_id, n_adults, n_children, age_of_youngest FROM volunteer ORDER BY last_name, first_name, email_address";
    private static final String UPDATE_VOLUNTEER = "UPDATE volunteer SET first_name=?, last_name=?, email_address=?, phone_number=?, fk_organization_id=?, other_organization=?, n_adults=?, n_children=?, age_of_youngest=? WHERE id=?";
    private static final String DELETE_VOLUNTEER = "DELETE FROM volunteer WHERE id=?";
    private static final String ADD_VOLUNTEER = "INSERT INTO volunteer (first_name, last_name, email_address, phone_number, fk_organization_id, other_organization, n_adults, n_children, age_of_youngest) VALUES (?,?,?,?,?,?,?,?,?)";

    private static VolunteerManager uniqueInstance = null;

    private static final ReservationManager reservationManager = ReservationManager.getInstance();

    private static ArrayList<Volunteer> volunteers;

    public static synchronized VolunteerManager getInstance() {
        if (VolunteerManager.uniqueInstance == null) {
            VolunteerManager.uniqueInstance = new VolunteerManager();
        }
        return VolunteerManager.uniqueInstance;
    }

    @Override
    protected VolunteerManager clone() throws CloneNotSupportedException {
        throw new CloneNotSupportedException("Cloning of singleton is not supported");
    }

    private VolunteerManager() {}

    public synchronized ArrayList<Volunteer> getVolunteers() {
        if (volunteers == null) {
            volunteers = new ArrayList<>();
            try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
                 Statement statement = connection.createStatement();
                 ResultSet resultSet = statement.executeQuery(SELECT_ALL_VOLUNTEERS)) {

                while (resultSet.next()) {
                    Volunteer volunteer = new Volunteer();
                    volunteer.setId(resultSet.getInt("id"));
                    volunteer.setLastName(resultSet.getString("last_name"));
                    volunteer.setFirstName(resultSet.getString("first_name"));
                    volunteer.setEmailAddress(resultSet.getString("email_address"));
                    volunteer.setPhoneNumber(resultSet.getString("phone_number"));
                    volunteer.setOrganizationId(resultSet.getInt("fk_organization_id"));
                    volunteer.setOtherOrganization(resultSet.getString("other_organization"));
                    volunteer.setAdults(resultSet.getInt("n_adults"));
                    volunteer.setChildren(resultSet.getInt("n_children"));
                    volunteer.setYoungest(resultSet.getInt("age_of_youngest"));
                    volunteers.add(volunteer);
                }
            } catch (Exception e) {
                logger.error(e.getLocalizedMessage());
            }
        }
        Collections.sort(volunteers);
        return volunteers;
    }

    public Volunteer getVolunteer(int volunteerId) {
        for (Volunteer volunteer : getVolunteers()) {
            if (volunteer.getId() == volunteerId) {
                return volunteer;
            }
        }
        return null;
    }

    public Volunteer getVolunteer(String emailAddress, String firstName, String lastName, int adults,
                                  int children, int youngest) {
        for (Volunteer volunteer : getVolunteers()) {
            if (volunteer.getEmailAddress().equals(emailAddress) &&
                    volunteer.getFirstName().equals(firstName) &&
                    volunteer.getLastName().equals(lastName) &&
                    volunteer.getAdults() == adults &&
                    volunteer.getChildren() == children &&
                    volunteer.getYoungest() == youngest) {
                return volunteer;
            }
        }
        return null;
    }

    public synchronized void addVolunteer(String firstName, String lastName, String emailAddress, String phoneNumber,
                                          int organizationId, String otherOrganization, int adults, int children, int youngest) {
        // Update the database copy
        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(ADD_VOLUNTEER, Statement.RETURN_GENERATED_KEYS)) {
            preparedStatement.setString(1, firstName);
            preparedStatement.setString(2, lastName);
            preparedStatement.setString(3, emailAddress);
            preparedStatement.setString(4, phoneNumber);
            preparedStatement.setInt(5, organizationId);
            preparedStatement.setString(6, otherOrganization);
            preparedStatement.setInt(7, adults);
            preparedStatement.setInt(8, children);
            preparedStatement.setInt(9, youngest);
            preparedStatement.executeUpdate();
            ResultSet resultSet = preparedStatement.getGeneratedKeys();
            resultSet.next();
            int id = resultSet.getInt(1);
            Volunteer volunteer = new Volunteer();
            volunteer.setId(id);
            volunteer.setFirstName(firstName);
            volunteer.setLastName(lastName);
            volunteer.setEmailAddress(emailAddress);
            volunteer.setPhoneNumber(phoneNumber);
            volunteer.setOrganizationId(organizationId);
            volunteer.setOtherOrganization(otherOrganization);
            volunteer.setAdults(adults);
            volunteer.setChildren(children);
            volunteer.setYoungest(youngest);
            volunteers.add(volunteer);
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());
        }
    }

    public synchronized void updateVolunteer(int id, String firstName, String lastName, String emailAddress, String phoneNumber,
                                             int organizationId, String otherOrganization, int adults, int children, int youngest) {
        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_VOLUNTEER)) {
            preparedStatement.setString(1, firstName);
            preparedStatement.setString(2, lastName);
            preparedStatement.setString(3, emailAddress);
            preparedStatement.setString(4, phoneNumber);
            preparedStatement.setInt(5, organizationId);
            preparedStatement.setString(6, otherOrganization);
            preparedStatement.setInt(7, adults);
            preparedStatement.setInt(8, children);
            preparedStatement.setInt(9, youngest);
            preparedStatement.setInt(10, id);
            int rowsUpdated = preparedStatement.executeUpdate();
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());
        }

        // Update the in-memory volunteer
        Volunteer volunteer = getVolunteer(id);
        volunteer.setFirstName(firstName);
        volunteer.setLastName(lastName);
        volunteer.setEmailAddress(emailAddress);
        volunteer.setPhoneNumber(phoneNumber);
        volunteer.setOrganizationId(organizationId);
        volunteer.setOtherOrganization(otherOrganization);
        volunteer.setAdults(adults);
        volunteer.setChildren(children);
        volunteer.setYoungest(youngest);
    }

    public synchronized void deleteVolunteer(int volunteerId) {
        reservationManager.deleteReservationsForVolunteer(volunteerId);
        deleteObject(DELETE_VOLUNTEER, volunteerId);
        volunteers.removeIf(v -> v.getId() == volunteerId);
    }

    public void deleteVolunteerIfNoReservations(Volunteer volunteer) {
        if (reservationManager.getReservationCountByVolunteer(volunteer) == 0) {
            deleteVolunteer(volunteer.getId());
        }
    }
}
