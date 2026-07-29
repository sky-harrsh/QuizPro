package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static String getEnv(String name, String defaultValue) {
        String val = System.getenv(name);
        return (val != null && !val.trim().isEmpty()) ? val.trim() : defaultValue;
    }

    public static Connection getConnection() {
        String dbHost = getEnv("MYSQLHOST", getEnv("DB_HOST", "localhost"));
        String dbPort = getEnv("MYSQLPORT", getEnv("DB_PORT", "3306"));
        String dbName = getEnv("MYSQLDATABASE", getEnv("DB_NAME", "quizdb"));
        String user = getEnv("MYSQLUSER", getEnv("DB_USER", "root"));
        String pass = getEnv("MYSQLPASSWORD", getEnv("DB_PASSWORD", ""));

        String defaultUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
        String url = getEnv("JDBC_DATABASE_URL", getEnv("DB_URL", defaultUrl));

        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("❌ Database Connection Failed: " + e.getMessage());
            e.printStackTrace();
        }
        return connection;
    }
}
