package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for obtaining a MySQL database connection.
     * Reads connection parameters from environment variables:
 *   MYSQLHOST, MYSQLPORT, MYSQLDATABASE, MYSQLUSER, MYSQLPASSWORD
      *
      * The method returns a live {@link Connection} or throws an exception
     * if the connection cannot be established.
     */
public class DBConnection {
        private static final String DEFAULT_HOST = "localhost";
        private static final String DEFAULT_PORT = "3306";
        private static final String DEFAULT_DB   = "quizdb";
        private static final String DEFAULT_USER = "root";
        private static final String DEFAULT_PASS = "";

    /**
     * Returns a new {@link Connection} to the MySQL database.
         *
         * @return a live JDBC connection
         * @throws SQLException if a database access error occurs
         */
    public static Connection getConnection() throws SQLException {
                // Load MySQL driver
            try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                            throw new SQLException("MySQL JDBC Driver not found", e);
            }

            // Retrieve environment variables (fallback to defaults for local dev)
            String host = System.getenv("MYSQLHOST");
                String port = System.getenv("MYSQLPORT");
                String db   = System.getenv("MYSQLDATABASE");
                String user = System.getenv("MYSQLUSER");
                String pass = System.getenv("MYSQLPASSWORD");

            if (host == null || host.isEmpty()) host = DEFAULT_HOST;
                if (port == null || port.isEmpty()) port = DEFAULT_PORT;
                if (db   == null || db.isEmpty())   db   = DEFAULT_DB;
                if (user == null || user.isEmpty()) user = DEFAULT_USER;
                if (pass == null) pass = DEFAULT_PASS;

            String url = String.format(
                                "jdbc:mysql://%s:%s/%s?sslMode=VERIFY_IDENTITY&serverTimezone=UTC&characterEncoding=UTF-8",
                                host, port, db);

            return DriverManager.getConnection(url, user, pass);
    }
}
