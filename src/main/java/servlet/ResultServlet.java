package servlet;

import db.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ResultServlet")
public class ResultServlet extends HttpServlet {
    private static String getApiKey(HttpServlet servlet) {
        // 1. Check environment variable first (production / Render)
        String envKey = System.getenv("ANTHROPIC_API_KEY");
        if (envKey != null && !envKey.trim().isEmpty()
                && !envKey.trim().equals("YOUR_ACTUAL_ANTHROPIC_KEY_HERE")) {
            return envKey.trim();
        }
        // 2. Fall back to config.properties (local development)
        try {
            String path = servlet.getServletContext()
                                 .getRealPath("/WEB-INF/config.properties");
            java.util.Properties props = new java.util.Properties();
            props.load(new java.io.FileInputStream(path));
            String key = props.getProperty("anthropic.api.key", "").trim();
            System.err.println("API Key loaded, length: " + key.length()
                             + ", starts with: " + (key.length() > 10 ? key.substring(0,10) : key));
            return key;
        } catch (Exception e) {
            System.err.println("FAILED to load config.properties: " + e.getMessage());
            return "";
        }
    }

    private Map<Integer, String> fetchExplanations(String apiKey, List<Map<String,String>> questions) {
        Map<Integer, String> result = new HashMap<>();
        try {
            // Build questions JSON
            StringBuilder qArray = new StringBuilder("[");
            for (int i = 0; i < questions.size(); i++) {
                Map<String,String> q = questions.get(i);
                if (i > 0) qArray.append(",");
                qArray.append("{")
                      .append("\"index\":").append(i).append(",")
                      .append("\"question\":\"").append(escapeJson(q.get("question"))).append("\",")
                      .append("\"correctAnswer\":\"").append(escapeJson(q.get("correctAnswer"))).append("\"")
                      .append("}");
            }
            qArray.append("]");

            String userContent = "For each Java quiz question below, write a clear 2-3 sentence "
                + "technical explanation of WHY the correct answer is correct. "
                + "Explain the concept properly like a teacher. "
                + "Do NOT say 'Review this topic' or 'refer to study notes'. "
                + "Return ONLY a valid JSON array. Each object must have: "
                + "index (integer, 0-based) and explanation (string). "
                + "Questions: " + qArray.toString();

            String requestBody = "{"
                + "\"model\":\"claude-3-5-sonnet-20241022\","
                + "\"max_tokens\":3000,"
                + "\"messages\":[{"
                + "\"role\":\"user\","
                + "\"content\":\"" + escapeJson(userContent) + "\""
                + "}]"
                + "}";

            System.err.println("Sending to Anthropic API, body length: " + requestBody.length());

            java.net.URL url = java.net.URI.create("https://api.anthropic.com/v1/messages").toURL();
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("x-api-key", apiKey);
            conn.setRequestProperty("anthropic-version", "2023-06-01");
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(30000);
            conn.setDoOutput(true);

            try (java.io.OutputStream os = conn.getOutputStream()) {
                os.write(requestBody.getBytes("UTF-8"));
            }

            int responseCode = conn.getResponseCode();
            System.err.println("Anthropic response code: " + responseCode);

            java.io.InputStream is = (responseCode == 200)
                ? conn.getInputStream()
                : conn.getErrorStream();

            java.io.BufferedReader reader = new java.io.BufferedReader(
                new java.io.InputStreamReader(is, "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
            String rawResponse = sb.toString();

            System.err.println("Raw response (first 500 chars): "
                + rawResponse.substring(0, Math.min(500, rawResponse.length())));

            if (responseCode != 200) {
                System.err.println("API ERROR BODY: " + rawResponse);
                return result;
            }

            // Extract text content from Claude response envelope
            int textIdx = rawResponse.indexOf("\"text\":\"");
            if (textIdx == -1) {
                System.err.println("Could not find 'text' field in response");
                return result;
            }
            
            // Extract the text value properly handling escaped quotes
            StringBuilder textContent = new StringBuilder();
            int pos = textIdx + 8;
            while (pos < rawResponse.length()) {
                char c = rawResponse.charAt(pos);
                if (c == '\\' && pos + 1 < rawResponse.length()) {
                    char next = rawResponse.charAt(pos + 1);
                    if (next == '"') { textContent.append('"'); pos += 2; continue; }
                    if (next == 'n') { textContent.append('\\'); textContent.append('n'); pos += 2; continue; }
                    if (next == '\\') { textContent.append('\\'); pos += 2; continue; }
                }
                if (c == '"') break;
                textContent.append(c);
                pos++;
            }
            String jsonArray = textContent.toString().trim();
            // Evaluate nested literal \n into spaces since we are scraping pure strings
            jsonArray = jsonArray.replace("\\n", " ");

            // Strip markdown fences
            if (jsonArray.startsWith("```")) {
                jsonArray = jsonArray.replaceAll("(?s)```[a-z]*\\n?", "").replaceAll("```", "").trim();
            }

            System.err.println("Extracted JSON array (first 300): "
                + jsonArray.substring(0, Math.min(300, jsonArray.length())));

            // Parse JSON array manually
            int searchPos = 0;
            while ((searchPos = jsonArray.indexOf("\"index\"", searchPos)) != -1) {
                try {
                    int colonIdx = jsonArray.indexOf(":", searchPos) + 1;
                    int commaIdx = jsonArray.indexOf(",", colonIdx);
                    if(commaIdx == -1) commaIdx = jsonArray.indexOf("}", colonIdx);
                    int idx = Integer.parseInt(jsonArray.substring(colonIdx, commaIdx).trim());

                    int expLabelIdx = jsonArray.indexOf("\"explanation\"", commaIdx);
                    int expColonIdx = jsonArray.indexOf(":", expLabelIdx) + 1;
                    while (expColonIdx < jsonArray.length() &&
                           (jsonArray.charAt(expColonIdx) == ' ' ||
                            jsonArray.charAt(expColonIdx) == '"')) expColonIdx++;

                    StringBuilder expBuilder = new StringBuilder();
                    int expPos = expColonIdx;
                    while (expPos < jsonArray.length()) {
                        char ch = jsonArray.charAt(expPos);
                        if (ch == '\\' && expPos + 1 < jsonArray.length()) {
                            expBuilder.append(jsonArray.charAt(expPos + 1));
                            expPos += 2; continue;
                        }
                        if (ch == '"') break;
                        expBuilder.append(ch);
                        expPos++;
                    }
                    result.put(idx, expBuilder.toString().trim());
                    System.err.println("Parsed explanation for index " + idx
                        + ": " + expBuilder.toString().substring(0, Math.min(60, expBuilder.length())));
                    searchPos = expPos;
                } catch (Exception e) {
                    System.err.println("Error parsing at pos " + searchPos + ": " + e.getMessage());
                    searchPos++;
                }
            }
            System.err.println("Total explanations parsed: " + result.size());

        } catch (Exception e) {
            System.err.println("fetchExplanations EXCEPTION: " + e.getClass().getName()
                + " — " + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }

    private boolean isLoggedIn(HttpSession session) {
        if (session == null) return false;
        return session.getAttribute("userId") != null
            || session.getAttribute("username") != null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!isLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get questions from session (stored by QuizServlet)
        @SuppressWarnings("unchecked")
        List<Map<String, String>> questions =
            (List<Map<String, String>>) session.getAttribute("quizQuestions");

        if (questions == null || questions.isEmpty()) {
            System.err.println("ERROR: quizQuestions is null in session!");
            response.sendRedirect("dashboard.jsp?msg=error");
            return;
        }

        System.err.println("ResultServlet: processing " + questions.size() + " questions");

        // Calculate score by comparing submitted answers to correct answers
        int score = 0;
        List<Map<String, String>> reviewData = new ArrayList<>();

        for (int i = 0; i < questions.size(); i++) {
            Map<String, String> q = questions.get(i);
            String correctAnswer = q.get("correctAnswer");
            String userAnswer = request.getParameter("answer_" + i);
            if (userAnswer == null) userAnswer = "";

            System.err.println("Q" + i + ": correct=" + correctAnswer
                + " | user=" + userAnswer
                + " | match=" + correctAnswer.equals(userAnswer));

            if (correctAnswer.equals(userAnswer)) score++;

            Map<String, String> reviewEntry = new HashMap<>(q);
            reviewEntry.put("userAnswer", userAnswer);
            reviewEntry.put("isCorrect", String.valueOf(correctAnswer.equals(userAnswer)));
            reviewData.add(reviewEntry);
        }

        int totalQuestions = questions.size();
        System.err.println("Final score: " + score + " / " + totalQuestions);

        // Save score to database
        String category = (String) session.getAttribute("currentCategory");
        if (category == null) category = "general";

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO results (user_id, score, total_questions, category) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            
            // Safe way to get userId regardless of how it was stored
            int userId = 0;
            Object userIdObj = session.getAttribute("userId");
            if (userIdObj instanceof Integer) {
                userId = (Integer) userIdObj;
            } else if (userIdObj instanceof String) {
                try { userId = Integer.parseInt((String) userIdObj); }
                catch (NumberFormatException e) { userId = 0; }
            }
            pstmt.setInt(1, userId);
            pstmt.setInt(2, score);
            pstmt.setInt(3, totalQuestions);
            pstmt.setString(4, category);
            pstmt.executeUpdate();
            conn.close();
        } catch (Exception e) {
            System.err.println("DB save error: " + e.getMessage());
        }

        // Fetch AI explanations
        String apiKey = getApiKey(this);
        Map<Integer, String> explanationMap = fetchExplanations(apiKey, questions);

        // Set all attributes for result.jsp
        request.setAttribute("score", score);
        request.setAttribute("totalQuestions", totalQuestions);
        request.setAttribute("percentage", (int) Math.round((score * 100.0) / totalQuestions));
        request.setAttribute("reviewData", reviewData);
        request.setAttribute("explanationMap", explanationMap);
        request.setAttribute("category", category);

        // Forward to result.jsp — NOT redirect (redirect loses attributes)
        request.getRequestDispatcher("result.jsp").forward(request, response);
    }
}
