import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.ResultSet;

public class CheckQuizzes {
    public static void main(String[] args) {
        String URL = "jdbc:mysql://localhost:3306/quizdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
        String USERNAME = "root";
        String PASSWORD = "176023"; 
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM questions");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("id") + " Cat: '" + rs.getString("category") + "' Q: " + rs.getString("question").substring(0, Math.min(20, rs.getString("question").length())));
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
