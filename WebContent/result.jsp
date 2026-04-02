<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Result - Online Quiz</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Confetti JS for passing score -->
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
</head>
<body>
    <div class="nav">
        <h2><i class="fa-solid fa-graduation-cap"></i> QuizPro</h2>
        <div>
            <span>Welcome, <%= session.getAttribute("username") %>!</span>
            <a href="LogoutServlet"><i class="fa-solid fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>
    
    <div class="container text-center" style="max-width: 600px; margin-top: 60px;">
        <h2 style="margin-bottom: 30px;">Quiz Successfully Completed!</h2>
        
        <%
            Integer score = (Integer) request.getAttribute("score");
            Integer total = (Integer) request.getAttribute("total");
            if (score != null && total != null) {
                double percentage = ((double)score / total) * 100;
                boolean passed = percentage >= 50;
        %>
            <div class="result-circle <%= passed ? "" : "fail" %>">
                <%= score %> / <%= total %>
            </div>
            
            <h3 <%= "style=\"font-size: 28px; margin-bottom: 10px; color: " + (passed ? "var(--success)" : "var(--danger)") + ";\"" %>>
                <%= String.format("%.0f", percentage) %>%
            </h3>
            
            <p style="font-size: 18px; color: var(--text-muted); margin-bottom: 40px;">
                <% if(passed) { %>
                    <i class="fa-solid fa-star" style="color: #f1c40f;"></i> Excellent work! You have a great grasp of the concepts!
                    <script>
                        setTimeout(() => {
                            confetti({ particleCount: 150, spread: 80, origin: { y: 0.6 } });
                        }, 500);
                    </script>
                <% } else { %>
                    <i class="fa-solid fa-triangle-exclamation"></i> Keep practicing! Review the topics and try again when you're ready.
                <% } %>
            </p>
        <%
            } else {
        %>
            <div class="alert alert-error">Results not available. Did you submit a quiz?</div>
        <%
            }
        %>
        
        <br>
        <a href="dashboard.jsp" class="btn" style="padding: 15px 30px;"><i class="fa-solid fa-rotate-right"></i> Take Another Quiz</a>
    </div>
</body>
</html>
