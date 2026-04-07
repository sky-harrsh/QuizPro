package servlet;

import model.Question;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class AIQuestionGenerator {
    private static String getApiKey(javax.servlet.ServletContext context) {
        if (context == null)
            return "";
        try {
            String path = context.getRealPath("/WEB-INF/config.properties");
            java.util.Properties props = new java.util.Properties();
            props.load(new java.io.FileInputStream(path));
            return props.getProperty("anthropic.api.key", "").trim();
        } catch (Exception e) {
            return "";
        }
    }

    public static List<Question> generateAIQuestions(String category, int count, javax.servlet.ServletContext context) {
        List<Question> questions = new ArrayList<>();
        String apiKey = getApiKey(context);
        if (apiKey == null || apiKey.isEmpty() || apiKey.equals("YOUR_ACTUAL_ANTHROPIC_KEY_HERE"))
            return questions;

        try {
            URL url = URI.create("https://api.anthropic.com/v1/messages").toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("x-api-key", apiKey);
            conn.setRequestProperty("anthropic-version", "2023-06-01");
            conn.setRequestProperty("content-type", "application/json");
            conn.setDoOutput(true);

            String prompt = "Generate " + count + " Java quiz questions for the category: " + category + ". " +
                    "Include at least 2 questions that show a short Java code snippet and ask what the output or behavior is. "
                    +
                    "Each question must have exactly 4 options with only 1 correct answer. " +
                    "Make questions different every time - vary difficulty from easy to hard. " +
                    "Return ONLY a valid JSON array where each object has: " +
                    "\\\"question\\\": string (for code questions, include the code inside <pre> tags), " +
                    "\\\"option1\\\": string, " +
                    "\\\"option2\\\": string, " +
                    "\\\"option3\\\": string, " +
                    "\\\"option4\\\": string, " +
                    "\\\"correct_answer\\\": string (must exactly match one of the options). " +
                    "No markdown, no explanation, ONLY the JSON array.";

            String payload = "{\"model\": \"claude-3-5-sonnet-20241022\", \"max_tokens\": 2000, \"messages\": [{\"role\": \"user\", \"content\": \""
                    + prompt + "\"}]}";

            try (OutputStream os = conn.getOutputStream()) {
                os.write(payload.getBytes("UTF-8"));
            }

            if (conn.getResponseCode() == 200) {
                try (Scanner scanner = new Scanner(conn.getInputStream(), "UTF-8").useDelimiter("\\A")) {
                    String response = scanner.hasNext() ? scanner.next() : "";

                    if (response.contains("```json")) {
                        response = response.substring(response.indexOf("```json") + 7);
                    } else if (response.contains("```")) {
                        response = response.substring(response.indexOf("```") + 3);
                    }
                    if (response.lastIndexOf("```") > -1) {
                        response = response.substring(0, response.lastIndexOf("```"));
                    }

                    int i = 0;
                    while (true) {
                        int startObj = response.indexOf("{", i);
                        int endObj = response.indexOf("}", startObj);
                        if (startObj == -1 || endObj == -1)
                            break;

                        String objStr = response.substring(startObj, endObj);
                        String q = extractJsonField(objStr, "question");
                        String o1 = extractJsonField(objStr, "option1");
                        String o2 = extractJsonField(objStr, "option2");
                        String o3 = extractJsonField(objStr, "option3");
                        String o4 = extractJsonField(objStr, "option4");
                        String ca = extractJsonField(objStr, "correct_answer");

                        if (q != null && o1 != null && o2 != null && o3 != null && o4 != null && ca != null) {
                            Question qq = new Question();
                            qq.setId(9000 + questions.size() + 1);
                            qq.setCategory(category);
                            qq.setQuestion(q);
                            qq.setOption1(o1);
                            qq.setOption2(o2);
                            qq.setOption3(o3);
                            qq.setOption4(o4);
                            qq.setCorrectAnswer(ca);
                            questions.add(qq);
                        }
                        i = endObj;
                    }
                }
            } else {
                System.err.println("AI Gen HTTP Error: " + conn.getResponseCode());
            }

        } catch (Exception e) {
            System.err.println("AI Gen Exception: " + e.getMessage());
            e.printStackTrace();
        }
        return questions;
    }

    private static String extractJsonField(String obj, String field) {
        String key = "\"" + field + "\"";
        int kIdx = obj.indexOf(key);
        if (kIdx == -1)
            return null;
        int valStart = obj.indexOf("\"", kIdx + key.length() + 1);
        if (valStart == -1)
            return null;
        valStart += 1;
        int valEnd = obj.indexOf("\"", valStart);
        while (valEnd > 0 && obj.charAt(valEnd - 1) == '\\') {
            valEnd = obj.indexOf("\"", valEnd + 1);
        }
        if (valStart > 0 && valEnd > valStart) {
            return obj.substring(valStart, valEnd).replace("\\\"", "\"").replace("\\\\", "\\").replace("\\n", "\n");
        }
        return null;
    }
}
