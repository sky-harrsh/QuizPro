package servlet;

import db.DBConnection;
import model.Question;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/QuizServlet")
public class QuizServlet extends HttpServlet {
    private boolean isLoggedIn(HttpSession session) {
        if (session == null) return false;
        return session.getAttribute("userId") != null
            || session.getAttribute("username") != null;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!isLoggedIn(session)) {
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
            if (conn == null) {
                System.out.println("[QuizServlet] ❌ DB Connection NULL — redirecting to dashboard.jsp");
                response.sendRedirect("dashboard.jsp?msg=error&detail=Database+Connection+Failed");
                return;
            }

            String sql = "SELECT * FROM questions WHERE category = ? ORDER BY RAND() LIMIT ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, category);
                
                // First fetch AI questions
                List<Question> aiQuestions = AIQuestionGenerator.generateAIQuestions(category, 7, getServletContext());
                
                // Fetch DB questions accordingly (8 if AI worked, 15 if AI failed)
                int numDb = aiQuestions.isEmpty() ? 15 : 8;
                pstmt.setInt(2, numDb);
                try (ResultSet rs = pstmt.executeQuery()) {
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
                }
                
                questions.addAll(aiQuestions);
                Collections.shuffle(questions);

                System.out.println(
                        "[QuizServlet] ✅ Questions loaded for '" + category + "': " + (questions.size() - aiQuestions.size()) + " DB, " + aiQuestions.size() + " AI");
                
                if (questions.isEmpty()) {
                    System.out.println("[QuizServlet] ⚠️  No questions found for category '" + category
                            + "' — redirecting to dashboard.jsp");
                    response.sendRedirect("dashboard.jsp?msg=noquestions");
                    return;
                }
                
                session.setAttribute("currentCategory", category);
                session.setAttribute("questionsList", questions);
                
                // Provide Map format for ResultServlet
                List<java.util.Map<String, String>> quizQuestions = new ArrayList<>();
                for (Question q : questions) {
                    java.util.Map<String, String> map = new java.util.HashMap<>();
                    map.put("question", q.getQuestion());
                    map.put("option1", q.getOption1());
                    map.put("option2", q.getOption2());
                    map.put("option3", q.getOption3());
                    map.put("option4", q.getOption4());
                    map.put("correctAnswer", q.getCorrectAnswer());
                    quizQuestions.add(map);
                }
                session.setAttribute("quizQuestions", quizQuestions);
                
                // Critical fixes for quiz.jsp requirements
                session.setAttribute("category", category);
                session.setAttribute("questions", questions);

                request.setAttribute("questions", questions);
                System.out.println("[QuizServlet] 🚀 Forwarding to quiz.jsp for category: '" + category + "'");
                request.getRequestDispatcher("quiz.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            String detail = e.getMessage();
            if (detail == null) detail = e.getClass().getName();
            System.err.println("[QuizServlet] ❌ Exception: " + detail);
            response.sendRedirect("dashboard.jsp?msg=error&detail=" + java.net.URLEncoder.encode(detail, "UTF-8"));
        }
    }
}
