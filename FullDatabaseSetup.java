import java.sql.*;

public class FullDatabaseSetup {
    public static void main(String[] args) {
        String baseUri = "jdbc:mysql://localhost:3306/?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        String dbName = "quizdb";
        String user = "root";
        String pass = "";

        try (Connection conn = DriverManager.getConnection(baseUri, user, pass);
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Connecting to MySQL...");
            stmt.executeUpdate("CREATE DATABASE IF NOT EXISTS " + dbName);
            System.out.println("Database 'quizdb' ensured.");
            
            stmt.executeUpdate("USE " + dbName);
            
            // Create tables if they don't exist
            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "username VARCHAR(50) UNIQUE NOT NULL, " +
                    "password VARCHAR(100) NOT NULL, " +
                    "email VARCHAR(100), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            System.out.println("Table 'users' ensured.");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS questions (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "category VARCHAR(50), " +
                    "question TEXT, " +
                    "option1 TEXT, " +
                    "option2 TEXT, " +
                    "option3 TEXT, " +
                    "option4 TEXT, " +
                    "correct_answer TEXT)");
            System.out.println("Table 'questions' ensured.");

            stmt.executeUpdate("CREATE TABLE IF NOT EXISTS results (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT, " +
                    "score INT, " +
                    "total_questions INT DEFAULT 15, " +
                    "category VARCHAR(50) DEFAULT 'general', " +
                    "date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (user_id) REFERENCES users(id))");
            System.out.println("Table 'results' ensured.");

            System.out.println("Database setup complete!");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
