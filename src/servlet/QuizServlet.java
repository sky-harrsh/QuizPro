package servlet;

import db.DBConnection;
import model.Question;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/QuizServlet")
public class QuizServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("[QuizServlet] ⚠️  No session or userId — redirecting to login.jsp");
            response.sendRedirect("login.jsp");
            return;
        }

        String category = request.getParameter("category");
        System.out.println("[QuizServlet] 📂 Category received: '" + category + "'");
        if (category == null || category.trim().isEmpty()) {
            System.out.println("[QuizServlet] ⚠️  Category is null/empty — redirecting to dashboard.jsp");
            response.sendRedirect("dashboard.jsp");
            return;
        }

        List<Question> questions = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM questions WHERE category = ? ORDER BY RAND() LIMIT 8";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Question q = new Question();
                q.setId(rs.getInt("id"));
                q.setCategory(rs.getString("category"));
                q.setQuestion(rs.getString("question"));
                q.setOption1(rs.getString("option1"));
                q.setOption2(rs.getString("option2"));
                q.setOption3(rs.getString("option3"));
                q.setOption4(rs.getString("option4"));
                q.setCorrectAnswer(rs.getString("correct_answer"));
                questions.add(q);
            }
            System.out.println(
                    "[QuizServlet] ✅ Questions loaded for '" + category + "': " + questions.size() + " question(s)");
            if (questions.isEmpty()) {
                System.out.println("[QuizServlet] ⚠️  No questions found for category '" + category
                        + "' — redirecting to dashboard.jsp");
                response.sendRedirect("dashboard.jsp?msg=noquestions");
                return;
            }
            // Store questions in session to verify correct answers later
            session.setAttribute("questionsList", questions);
            request.setAttribute("questions", questions);
            System.out.println("[QuizServlet] 🚀 Forwarding to quiz.jsp for category: '" + category + "'");
            request.getRequestDispatcher("quiz.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[QuizServlet] ❌ Exception for category '" + category + "': " + e.getMessage()
                    + " — redirecting to dashboard.jsp?msg=error");
            response.sendRedirect("dashboard.jsp?msg=error");
        }
    }
}
