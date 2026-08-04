package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection — Production-ready database connection factory.
 *
 * Reads Railway MySQL environment variables at runtime:
 *   MYSQLHOST       — hostname of the Railway MySQL service
 *   MYSQLPORT       — port (typically 3306)
 *   MYSQLDATABASE   — database name (quizdb)
 *   MYSQLUSER       — database user
 *   MYSQLPASSWORD   — database password
 *
 * Optionally, a full JDBC URL can be passed via JDBC_DATABASE_URL or DB_URL
 * which takes priority over the individual variables.
 *
 * In local development, secondary fallbacks DB_HOST / DB_PORT / DB_NAME /
 * DB_USER / DB_PASSWORD are also supported so no code change is needed
 * between environments.
 */
public class DBConnection {

    // ── Helper: read env var, returning null if absent or blank ──────────────
    private static String getEnv(String name) {
        String val = System.getenv(name);
        return (val != null && !val.trim().isEmpty()) ? val.trim() : null;
    }

    // ── Helper: read env var with an explicit default ─────────────────────────
    private static String getEnv(String name, String defaultValue) {
        String val = getEnv(name);
        return (val != null) ? val : defaultValue;
    }

    // ─────────────────────────────────────────────────────────────────────────
    public static Connection getConnection() {

        // 1. Determine each connection parameter from environment variables.
        //    Railway injects MYSQLHOST / MYSQLPORT / MYSQLDATABASE / MYSQLUSER / MYSQLPASSWORD.
        //    Secondary DB_* variables can be used for local / alternative environments.
        String dbHost = getEnv("MYSQLHOST",     getEnv("DB_HOST",     null));
        String dbPort = getEnv("MYSQLPORT",     getEnv("DB_PORT",     "3306"));
        String dbName = getEnv("MYSQLDATABASE", getEnv("DB_NAME",     null));
        String dbUser = getEnv("MYSQLUSER",     getEnv("DB_USER",     null));
        String dbPass = getEnv("MYSQLPASSWORD", getEnv("DB_PASSWORD", ""));

        // 2. Validate required variables — fail fast with a clear message.
        if (dbHost == null) {
            System.err.println("❌ [DBConnection] FATAL: Environment variable 'MYSQLHOST' is not set.");
            System.err.println("   ➜ Set MYSQLHOST on Render to the Railway MySQL hostname.");
            return null;
        }
        if (dbName == null) {
            System.err.println("❌ [DBConnection] FATAL: Environment variable 'MYSQLDATABASE' is not set.");
            System.err.println("   ➜ Set MYSQLDATABASE on Render to 'quizdb' (or your Railway DB name).");
            return null;
        }
        if (dbUser == null) {
            System.err.println("❌ [DBConnection] FATAL: Environment variable 'MYSQLUSER' is not set.");
            System.err.println("   ➜ Set MYSQLUSER on Render to the Railway MySQL username.");
            return null;
        }

        // 3. Build the JDBC URL (Railway-compatible).
        //    A pre-built URL in JDBC_DATABASE_URL / DB_URL takes the highest priority.
        String defaultUrl = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName
                + "?allowPublicKeyRetrieval=true"
                + "&useSSL=false"
                + "&serverTimezone=UTC"
                + "&characterEncoding=UTF-8";

        String url = getEnv("JDBC_DATABASE_URL", getEnv("DB_URL", defaultUrl));

        // 4. Establish connection.
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(url, dbUser, dbPass);
            System.out.println("✅ [DBConnection] Connected to Railway MySQL at " + dbHost + ":" + dbPort + "/" + dbName);
            return connection;

        } catch (ClassNotFoundException e) {
            System.err.println("❌ [DBConnection] MySQL JDBC Driver not found on classpath: " + e.getMessage());
            System.err.println("   ➜ Ensure 'mysql-connector-j' is declared as a dependency in pom.xml.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("❌ [DBConnection] Database connection failed to " + dbHost + ":" + dbPort + "/" + dbName);
            System.err.println("   ➜ Verify MYSQLHOST, MYSQLPORT, MYSQLDATABASE, MYSQLUSER, MYSQLPASSWORD on Render.");
            System.err.println("   ➜ SQL State: " + e.getSQLState() + " | Error Code: " + e.getErrorCode());
            System.err.println("   ➜ Message  : " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
