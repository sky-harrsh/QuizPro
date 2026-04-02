package servlet;

import db.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        System.out.println("Login attempt for email: " + email);

        try (Connection conn = DBConnection.getConnection()) {

            // ✅ Check connection first
            if (conn == null) {
                System.out.println("❌ DB Connection Failed - redirecting to login.jsp?msg=dberror");
                response.sendRedirect("login.jsp?msg=dberror");
                return;
            } else {
                System.out.println("✅ DB Connected");
            }

            String sql = "SELECT * FROM `users` WHERE `email`=? AND `password`=?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, email);
                pstmt.setString(2, password);

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        System.out.println("✅ User found in database.");
                        HttpSession session = request.getSession();

                        // ✅ safer column handling
                        session.setAttribute("userId", rs.getInt("id"));
                        session.setAttribute("username", rs.getString("username"));

                        System.out.println("✅ Login success - redirecting to dashboard.jsp for " + email);
                        response.sendRedirect("dashboard.jsp");
                    } else {
                        System.out.println("❌ Invalid email or password - redirecting to login.jsp?msg=invalid");
                        response.sendRedirect("login.jsp?msg=invalid");
                    }
                }
            }

        } catch (Exception e) {
            System.err.println("🔥 Exception in LoginServlet:");
            e.printStackTrace(); // 🔥 VERY IMPORTANT
            
            String errorMsg = e.getMessage();
            if (errorMsg == null) errorMsg = e.toString();
            System.out.println("🔥 Exception caught - redirecting to login.jsp?msg=exception for error: " + errorMsg);
            response.sendRedirect("login.jsp?msg=exception&detail=" + java.net.URLEncoder.encode(errorMsg, "UTF-8"));
        }
    }
}