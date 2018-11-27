package cc.nhf;

import org.apache.log4j.Logger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Objects;

import static cc.nhf.DatabaseUtil.getDataSource;

public class EmailManager {
    private static final Logger logger = Logger.getLogger("EmailManager");
    private static final String UPDATE_EMAIL = "UPDATE email SET subject=?, body=?, bcc=? WHERE id=?";
    private static final String GET_EMAILS = "SELECT id, subject, body, bcc FROM email";
    private static EmailManager uniqueInstance = null;
    private static ArrayList<Email> emails = null;

    public static synchronized EmailManager getInstance() {
        if (EmailManager.uniqueInstance == null) {
            EmailManager.uniqueInstance = new EmailManager();
        }
        return EmailManager.uniqueInstance;
    }

    @Override
    protected EmailManager clone() throws CloneNotSupportedException {
        throw new CloneNotSupportedException("Cloning of singleton not supported");
    }

    private EmailManager() {}

    private synchronized ArrayList<Email> getEmails() {
        if (emails == null) {
            emails = new ArrayList<>();

            try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
                 Statement statement = connection.createStatement();
                 ResultSet resultSet = statement.executeQuery(GET_EMAILS)) {
                while (resultSet.next()) {
                    Email email = new Email(resultSet.getString("id"),
                            resultSet.getString("subject"),
                            resultSet.getString("body"),
                            resultSet.getString("bcc"));
                    emails.add(email);
                }
            } catch (Exception e) {
                logger.error(e.getLocalizedMessage());
            }
        }
        return emails;
    }

    public synchronized Email getEmail(String id) {
        Email email = null;
        for (Email e : getEmails()) {
            if (e.getId().equals(id)) {
                email = e;
                break;
            }
        }
        return email;
    }

    public synchronized void updateEmail(String id, String subject, String body, String bcc) {
        Email email = this.getEmail(id);
        email.setSubject(subject);
        email.setBody(body);
        email.setBcc(bcc);

        // Update the database copy
        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_EMAIL)) {
            preparedStatement.setString(1, subject);
            preparedStatement.setString(2, body);
            preparedStatement.setString(3, bcc);
            preparedStatement.setString(4, id);
            preparedStatement.executeUpdate();
        } catch (Exception exception) {
            logger.error(exception.getLocalizedMessage());
        }
    }
}
