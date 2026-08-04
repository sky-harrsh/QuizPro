package servlet;

import db.DBConnection;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {

    private boolean isLoggedIn(HttpSession session) {
        if (session == null) return false;
        return session.getAttribute("userId") != null
            || session.getAttribute("username") != null;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!isLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Safe way to get userId regardless of how it was stored
        int userId = 0;
        Object userIdObj = session.getAttribute("userId");
        if (userIdObj instanceof Integer) {
            userId = (Integer) userIdObj;
        } else if (userIdObj instanceof String) {
            try { userId = Integer.parseInt((String) userIdObj); }
            catch (NumberFormatException e) { userId = 0; }
        }
        
        System.err.println("userId resolved to: " + userId);
        if (userId == 0) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");

        String email = "";
        String createdAt = "";
        int totalQuizzes = 0;
        int bestScore = 0;
        double overallScorePercent = 0.0;
        int totalCorrectAll = 0;
        int totalQsAll = 0;

        List<Map<String, Object>> scoreHistory = new ArrayList<>();
        Map<String, int[]> categoryTotals = new HashMap<>();
        categoryTotals.put("core", new int[]{0, 0}); // correct, total
        categoryTotals.put("oop", new int[]{0, 0});
        categoryTotals.put("advanced", new int[]{0, 0});
        categoryTotals.put("misc", new int[]{0, 0});

        try (Connection conn = DBConnection.getConnection()) {
            // User Data
            String uSql = "SELECT email, created_at FROM users WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(uSql);
            ps.setInt(1, userId);
            ResultSet rsUser = ps.executeQuery();
            if (rsUser.next()) {
                email = rsUser.getString("email");
                createdAt = rsUser.getString("created_at");
                if(createdAt != null && createdAt.length() > 10) createdAt = createdAt.substring(0, 10);
            }

            // Results History
            String rSql = "SELECT score, total_questions, category, date FROM results WHERE user_id = ? ORDER BY date DESC LIMIT 20";
            PreparedStatement psR = conn.prepareStatement(rSql);
            psR.setInt(1, userId);
            ResultSet rsHist = psR.executeQuery();
            while (rsHist.next()) {
                totalQuizzes++;
                int score = rsHist.getInt("score");
                int tq = rsHist.getInt("total_questions");
                String cat = rsHist.getString("category");
                String date = rsHist.getString("date");

                int percent = (int) Math.round(((double) score / tq) * 100);
                if (percent > bestScore) bestScore = percent;
                totalCorrectAll += score;
                totalQsAll += tq;

                Map<String, Object> map = new HashMap<>();
                map.put("score", score);
                map.put("total", tq);
                map.put("percent", percent);
                map.put("category", cat);
                map.put("date", date);
                scoreHistory.add(map);

                // Category Aggregation
                String mappedCat = "core";
                if(cat.toLowerCase().contains("oop")) mappedCat = "oop";
                else if(cat.toLowerCase().contains("advanced")) mappedCat = "advanced";
                else if(cat.toLowerCase().contains("misc")) mappedCat = "misc";

                int[] arr = categoryTotals.get(mappedCat);
                if(arr != null) {
                    arr[0] += score;
                    arr[1] += tq;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (totalQsAll > 0) overallScorePercent = ((double) totalCorrectAll / totalQsAll) * 100.0;

        // Extract category percents
        int coreP = categoryTotals.get("core")[1] > 0 ? (int) Math.round((categoryTotals.get("core")[0] / (double)categoryTotals.get("core")[1]) * 100) : 0;
        int oopP = categoryTotals.get("oop")[1] > 0 ? (int) Math.round((categoryTotals.get("oop")[0] / (double)categoryTotals.get("oop")[1]) * 100) : 0;
        int advP = categoryTotals.get("advanced")[1] > 0 ? (int) Math.round((categoryTotals.get("advanced")[0] / (double)categoryTotals.get("advanced")[1]) * 100) : 0;
        int miscP = categoryTotals.get("misc")[1] > 0 ? (int) Math.round((categoryTotals.get("misc")[0] / (double)categoryTotals.get("misc")[1]) * 100) : 0;

        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("createdAt", createdAt);
        request.setAttribute("totalQuizzes", totalQuizzes);
        request.setAttribute("bestScore", bestScore);
        request.setAttribute("overallScorePercent", overallScorePercent);
        request.setAttribute("scoreHistory", scoreHistory);
        request.setAttribute("catCore", coreP);
        request.setAttribute("catOop", oopP);
        request.setAttribute("catAdv", advP);
        request.setAttribute("catMisc", miscP);
        
        String tipsJson = "[]";
        if (totalQuizzes > 0) {
            try {
                String prompt = "A Java student has the following quiz performance:\n" +
                "- Overall average score: " + String.format("%.1f", overallScorePercent) + "%\n" +
                "- Category scores: Core Java " + coreP + "%, OOP " + oopP + "%, Advanced Java " + advP + "%, Miscellaneous " + miscP + "%\n" +
                "- Total quizzes taken: " + totalQuizzes + "\n" +
                "Give 5 specific, actionable study tips to help them improve. For each weak category (below 60%), give a specific Java topic they should focus on. " +
                "Format as a JSON array of objects with 'tip' (string) and 'priority' ('high'/'medium'/'low'). Return ONLY valid JSON array without markdown.";

                URL url = URI.create("https://api.anthropic.com/v1/messages").toURL();
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("POST");
                // Note: configure api key later if needed, but gracefully handle no key
                conn.setRequestProperty("x-api-key", System.getenv("ANTHROPIC_API_KEY") != null
                        ? System.getenv("ANTHROPIC_API_KEY").trim() : "");
                conn.setRequestProperty("anthropic-version", "2023-06-01");
                conn.setRequestProperty("content-type", "application/json");
                conn.setDoOutput(true);

                String payload = "{\"model\": \"claude-3-5-sonnet-20241022\", \"max_tokens\": 1000, \"messages\": [{\"role\": \"user\", \"content\": \"" + prompt.replace("\"", "\\\"").replace("\n", "\\n") + "\"}]}";
                try (OutputStream os = conn.getOutputStream()) {
                    os.write(payload.getBytes("UTF-8"));
                }
                if (conn.getResponseCode() == 200) {
                    try (Scanner scanner = new Scanner(conn.getInputStream(), "UTF-8").useDelimiter("\\A")) {
                        String responseBody = scanner.hasNext() ? scanner.next() : "";
                        if(responseBody.contains("```json")) {
                            responseBody = responseBody.substring(responseBody.indexOf("```json") + 7);
                        } else if(responseBody.contains("```")) {
                            responseBody = responseBody.substring(responseBody.indexOf("```") + 3);
                        }
                        if(responseBody.lastIndexOf("```") > -1) {
                            responseBody = responseBody.substring(0, responseBody.lastIndexOf("```"));
                        }
                        int startArr = responseBody.indexOf("[");
                        int endArr = responseBody.lastIndexOf("]");
                        if(startArr > -1 && endArr > startArr) {
                            tipsJson = responseBody.substring(startArr, endArr + 1).replace("\\n", " ");
                        }
                    }
                }
            } catch(Exception e) {
                System.err.println("AI Tips Gen failed: " + e.getMessage());
            }
        }
        
        request.setAttribute("tips", tipsJson); 

        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}
