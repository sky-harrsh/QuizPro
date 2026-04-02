package servlet;

import db.DBConnection;
import model.Question;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ResultServlet")
public class ResultServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        @SuppressWarnings("unchecked")
        List<Question> questions = (List<Question>) session.getAttribute("questionsList");
        
        if (questions == null) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        int score = 0;
        int totalQuestions = questions.size();

        for (Question q : questions) {
            String submittedAnswer = request.getParameter("q_" + q.getId());
            if (submittedAnswer != null && submittedAnswer.equals(q.getCorrectAnswer())) {
                score++;
            }
        }

        // Save score to database
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO results (user_id, score) VALUES (?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, score);
            pstmt.executeUpdate();
            
            // Set results for JSP
            request.setAttribute("score", score);
            request.setAttribute("total", totalQuestions);
            
            // Clear session question list
            session.removeAttribute("questionsList");
            
            request.getRequestDispatcher("result.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?msg=dberror");
        }
    }
}
