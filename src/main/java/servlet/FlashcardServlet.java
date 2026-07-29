package servlet;

import db.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/FlashcardServlet")
public class FlashcardServlet extends HttpServlet {
    private boolean isLoggedIn(HttpSession session) {
        if (session == null) return false;
        return session.getAttribute("userId") != null
            || session.getAttribute("username") != null;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (!isLoggedIn(session)) {
            out.print("{\"error\":\"unauthorized\"}");
            out.flush();
            return;
        }

        String category = request.getParameter("category");
        if (category == null || category.trim().isEmpty()) {
            category = "all";
        }

        StringBuilder jsonArray = new StringBuilder("[");
        try (Connection conn = DBConnection.getConnection()) {
            String sql;
            PreparedStatement pstmt;
            if ("all".equalsIgnoreCase(category)) {
                sql = "SELECT * FROM questions";
                pstmt = conn.prepareStatement(sql);
            } else {
                sql = "SELECT * FROM questions WHERE category = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, category);
            }

            ResultSet rs = pstmt.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    jsonArray.append(",");
                }
                first = false;

                jsonArray.append("{")
                        .append("\"id\":").append(rs.getInt("id")).append(",")
                        .append("\"category\":\"").append(escapeJson(rs.getString("category"))).append("\",")
                        .append("\"question\":\"").append(escapeJson(rs.getString("question"))).append("\",")
                        .append("\"option1\":\"").append(escapeJson(rs.getString("option1"))).append("\",")
                        .append("\"option2\":\"").append(escapeJson(rs.getString("option2"))).append("\",")
                        .append("\"option3\":\"").append(escapeJson(rs.getString("option3"))).append("\",")
                        .append("\"option4\":\"").append(escapeJson(rs.getString("option4"))).append("\",")
                        .append("\"correctAnswer\":\"").append(escapeJson(rs.getString("correct_answer"))).append("\"")
                        .append("}");
            }
            jsonArray.append("]");
            out.print(jsonArray.toString());
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"db_error\"}");
        }
        out.flush();
    }

    private String escapeJson(String text) {
        if (text == null)
            return "";
        return text.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
