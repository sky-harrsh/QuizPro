import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class TestConn {
    public static void main(String[] args) {
        String URL = "jdbc:mysql://localhost:3306/quizdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
        String USERNAME = "root";
        String PASSWORD = "176023"; 
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("✅ DB Connected");
            String sql = "ALTER TABLE questions ADD COLUMN category VARCHAR(50) DEFAULT 'core' AFTER id";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();
            System.out.println("✅ Added category column to questions table.");
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
