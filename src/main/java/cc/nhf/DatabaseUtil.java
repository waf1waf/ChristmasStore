package cc.nhf;

import org.jetbrains.annotations.Nullable;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DatabaseUtil {
	@Nullable
    public static DataSource getDataSource() throws NamingException {
		Context initialContext;
		Context environmentContext;
		String dataResourceName = "jdbc/ChristmasStoreDB";

		initialContext = new InitialContext();
		environmentContext = (Context) initialContext.lookup("java:comp/env");
		return (DataSource) environmentContext.lookup(dataResourceName);
	}
}
