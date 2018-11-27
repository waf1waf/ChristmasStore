package cc.nhf;

import org.apache.log4j.Logger;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Objects;

import static cc.nhf.DatabaseUtil.getDataSource;

class ObjectManager {
    private final Logger logger = Logger.getLogger(this.getClass());

    void deleteObject(String sqlStatement, int id) {
        try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sqlStatement)) {
            preparedStatement.setInt(1, id);

            preparedStatement.executeUpdate();

        } catch (Exception exception) {
            logger.error(exception.getLocalizedMessage());
        }
    }
}
