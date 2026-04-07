<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
        <%@ page import="java.util.Map" %>
            <% if (session.getAttribute("userId")==null) { response.sendRedirect("login.jsp"); return; } %>
                <%! private String getStaticExplanation(String question, String correctAnswer) {
                    return "\"" + correctAnswer + " \" is correct because this is a fundamental "
             + " Java concept. The other options describe different behaviors or "
             + " incorrect definitions. Study this topic in the OOP or Core Java "
             + " notes section for a full explanation with code examples."; } %>
                    <!DOCTYPE html>
                    <html>

                    <head>
                        <meta charset="UTF-8">
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                        <title>Result - Online Quiz</title>
                        <link rel="stylesheet" href="css/style.css">
                        <link rel="stylesheet" href="css/themes.css">
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                        <script
                            src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
                        <style>
                            .theme-fail {
                                border-color: #ef4444 !important;
                                color: #ef4444 !important;
                            }

                            .theme-warn {
                                border-color: #f59e0b !important;
                                color: #f59e0b !important;
                            }

                            .theme-pass {
                                border-color: #10b981 !important;
                                color: #10b981 !important;
                            }

                            .result-circle-anim {
                                width: 180px;
                                height: 180px;
                                margin: 0 auto 20px;
                                border-radius: 50%;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-size: 48px;
                                font-weight: bold;
                                border-width: 12px;
                                border-style: solid;
                                background: #f8fafc;
                                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                                transition: transform 0.5s ease-out;
                                animation: popIn 0.8s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
                            }

                            .h3-dynamic {
                                font-size: 32px;
                                margin-bottom: 10px;
                            }

                            .review-card {
                                background: white;
                                border-radius: 10px;
                                padding: 25px;
                                margin-bottom: 25px;
                                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                                border-left: 5px solid transparent;
                            }

                            .card-correct {
                                border-left-color: #10b981;
                            }

                            .card-wrong {
                                border-left-color: #ef4444;
                            }

                            .q-badge {
                                width: 30px;
                                height: 30px;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                border-radius: 50%;
                                font-weight: bold;
                                margin-right: 15px;
                                flex-shrink: 0;
                            }

                            .badge-correct {
                                background: #d1fae5;
                                color: #047857;
                            }

                            .badge-wrong {
                                background: #fee2e2;
                                color: #b91c1c;
                            }

                            .opt-base {
                                padding: 10px 15px;
                                border-radius: 6px;
                                margin-bottom: 8px;
                                border: 1px solid #e2e8f0;
                                font-size: 15px;
                            }

                            .opt-correct {
                                border-color: #10b981;
                                background-color: #ecfdf5;
                                color: #065f46;
                                font-weight: 500;
                            }

                            .opt-wrong {
                                border-color: #ef4444;
                                background-color: #fef2f2;
                                color: #991b1b;
                            }
                        </style>
                    </head>

                    <body class="dashboard-body">
                        <div class="nav">
                            <a href="dashboard.jsp" title="Go to Dashboard"
                                style="text-decoration: none; color: inherit;">
                                <h2 style="margin:0;"><i class="fa-solid fa-graduation-cap"></i> QuizPro</h2>
                            </a>
                            <div class="navbar-right">
    <button onclick="cycleTheme()" id="theme-btn" class="btn"
                                    style="background:transparent; border:1px solid rgba(255,255,255,0.3); padding: 5px 15px; border-radius: 5px; color: inherit; font-weight: bold;">🎨
                                    Dark</button>
    <a href="LogoutServlet"><i class="fa-solid fa-sign-out-alt"></i> Logout</a>
    <%
        String username = "";
        String initial = "U";
        if (session != null && session.getAttribute("username") != null) {
            username = (String) session.getAttribute("username");
            if (username != null && !username.isEmpty()) {
                initial = String.valueOf(username.charAt(0)).toUpperCase();
            }
        }
    %>
    <div class="profile-circle-wrapper">
        <a href="ProfileServlet" class="profile-circle" title="View Profile">
            <%= initial %>
        </a>
        <div class="profile-username-tag"><%= username %></div>
    </div>
</div></div>

                        <div class="container text-center" style="max-width: 600px; margin-top: 60px; background: rgba(255,255,255,0.97); border-radius: 20px; padding: 40px; box-shadow: 0 10px 25px rgba(0,0,0,0.2);">
                            <h2 style="margin-bottom: 30px; color: #1e293b;">Quiz Successfully Completed!</h2>

                            <% 
                                Integer score = (Integer) request.getAttribute("score");
                                Integer totalQuestions = (Integer) request.getAttribute("totalQuestions");
                                Integer percentage = (Integer) request.getAttribute("percentage");
                                
                                if (score == null) score = 0;
                                if (totalQuestions == null) totalQuestions = 0;
                                if (percentage == null) percentage = 0;
                                
                                if (totalQuestions > 0) { 
                                    boolean passed = percentage >= 70;
                                    String dynamicTheme = "theme-fail";
                                    if (percentage >= 70) { dynamicTheme = "theme-pass"; }
                                    else if (percentage >= 40) { dynamicTheme = "theme-warn"; }
                            %>
                                <div class="result-circle-anim <%= dynamicTheme %>">
                                    <%= score %> / <%= totalQuestions %>
                                </div>

                                <h3 class="h3-dynamic <%= dynamicTheme %>">
                                    <%= percentage %>%
                                </h3>

                                <p style="font-size: 18px; color: var(--text-muted); margin-bottom: 40px;">
                                    <% if(passed) { %>
                                        <i class="fa-solid fa-star" style="color: #f1c40f;"></i> Excellent work! You
                                        have a great grasp of the concepts!
                                        <script>
                                            setTimeout(() => {
                                                confetti({ particleCount: 150, spread: 80, origin: { y: 0.6 } });
                                            }, 500);
                                        </script>
                                        <% } else { %>
                                            <i class="fa-solid fa-triangle-exclamation"></i> Keep practicing! Review the
                                            topics and try again when you're ready.
                                            <% } %>
                                </p>

                                <div style="display: flex; gap: 15px; justify-content: center; margin-bottom: 20px;">
                                    <a href="dashboard.jsp" class="btn"
                                        style="padding: 15px 30px; background: #64748b; flex: 1;">
                                        <i class="fa-solid fa-home"></i> Back to Dashboard
                                    </a>
                                    <a href="javascript:history.back()" class="btn"
                                        style="padding: 15px 30px; flex: 1;">
                                        <i class="fa-solid fa-rotate-right"></i> Retake Quiz
                                    </a>
                                </div>

                                <button
                                    onclick="document.getElementById('answer-review').style.display='block'; this.style.display='none';"
                                    style="width: 100%; padding: 15px; border-radius: 8px; background: #10b981; color: white; border: none; font-size: 1.1rem; font-weight: bold; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 10px; margin-bottom: 40px;">
                                    <i class="fa-solid fa-clipboard-list"></i> View Answers & Solutions
                                </button>

                                <% } else { %>
                                    <div class="alert alert-error">Results not available. Did you submit a quiz?</div>
                                    <% } %>

                                        <%-- Answer Review Section --%>
                                        <% 
                                        @SuppressWarnings("unchecked") 
                                        List<Map<String, String>> reviewData = (List<Map<String, String>>) request.getAttribute("reviewData");
                                        @SuppressWarnings("unchecked")
                                        Map<Integer, String> explanationMap = (Map<Integer, String>) request.getAttribute("explanationMap");

                                        if (reviewData != null && !reviewData.isEmpty()) {
                                        %>
                                                            <div id="answer-review"
                                                                style="display: none; margin-top: 30px; text-align: left;">
                                                                <h3
                                                                    style="margin-bottom: 20px; font-size: 24px; color: #1e293b; border-bottom: 2px solid #e2e8f0; padding-bottom: 10px;">
                                                                    <i class="fa-solid fa-list-check"></i> Detailed
                                                                    Answer Review
                                                                </h3>

                                                                <% for (int i=0; i < reviewData.size(); i++) {
                                                                    Map<String, String> row = reviewData.get(i);
                                                                    String qIdStr = row.get("id");
                                                                    int qId = (qIdStr != null && !qIdStr.isEmpty()) ?
                                                                    Integer.parseInt(qIdStr) : -1;
                                                                    String qText = row.get("question");
                                                                    String uAns = row.get("userAnswer");
                                                                    String cAns = row.get("correctAnswer");

                                                                    String expl = "";
                                                                    if (explanationMap != null &&
                                                                    explanationMap.containsKey(qId)) {
                                                                    expl = explanationMap.get(qId);
                                                                    }
                                                                    if (expl == null || expl.isEmpty() ||
                                                                    expl.startsWith("[API")) {
                                                                    expl = "The correct answer is <strong>"
                                                                        + cAns + "</strong>. "
                                                                    + getStaticExplanation(qText, cAns);
                                                                    }

                                                                    boolean isCorrect = (uAns != null &&
                                                                    uAns.equals(cAns));
                                                                    %>
                                                                    <div class='review-card <%= isCorrect ? "card-correct" : "card-wrong" %>'>
                                                                        <div
                                                                            style="display: flex; align-items: flex-start; margin-bottom: 15px;">
                                                                            <span class='q-badge <%= isCorrect ? "badge-correct" : "badge-wrong" %>'>
                                                                                <%= (i+1) %>
                                                                            </span>
                                                                            <h4
                                                                                style="font-size: 18px; color: #334155; margin: 0; line-height: 1.4;">
                                                                                <%= qText %>
                                                                            </h4>
                                                                        </div>

                                                                        <div class="options-list"
                                                                            style="margin-left: 45px; margin-bottom: 20px;">
                                                                            <% String[] options={row.get("option1"),
                                                                                row.get("option2"), row.get("option3"),
                                                                                row.get("option4")}; for (String opt :
                                                                                options) { boolean
                                                                                isUserOpt=opt.equals(uAns); boolean
                                                                                isCorrectOpt=opt.equals(cAns); String
                                                                                optClass="opt-base" ; String
                                                                                icon="<i class='fa-regular fa-circle' style='color:#94a3b8; margin-right:10px;'></i>"
                                                                                ; if (isCorrectOpt) {
                                                                                optClass="opt-base opt-correct" ;
                                                                                icon="<i class='fa-solid fa-check-circle' style='color:#10b981; margin-right:10px;'></i>"
                                                                                ; } else if (isUserOpt && !isCorrectOpt)
                                                                                { optClass="opt-base opt-wrong" ;
                                                                                icon="<i class='fa-solid fa-times-circle' style='color:#ef4444; margin-right:10px;'></i>"
                                                                                ; } %>
                                                                                <div class="<%= optClass %>">
                                                                                    <%= icon %>
                                                                                        <%= opt %>
                                                                                            <% if (isUserOpt &&
                                                                                                isCorrectOpt) { %>
                                                                                                <span
                                                                                                    style="font-size: 12px; float: right; margin-top: 3px; font-weight: bold; color: #047857; background: #d1fae5; padding: 2px 8px; border-radius: 10px;">Correct!</span>
                                                                                                <% } else if (isUserOpt
                                                                                                    && !isCorrectOpt) {
                                                                                                    %>
                                                                                                    <span
                                                                                                        style="font-size: 12px; float: right; margin-top: 3px; font-weight: bold; color: #b91c1c;">Your
                                                                                                        Answer</span>
                                                                                                    <% } %>
                                                                                </div>
                                                                                <% } %>
                                                                        </div>

                                                                        <div class="explanation-box"
                                                                            style="margin-left: 45px; background: #eff6ff; padding: 15px; border-radius: 8px; border-left: 4px solid #3b82f6;">
                                                                            <strong
                                                                                style="color: #1e3a8a; font-size: 14px; margin-bottom: 5px; display: block;">
                                                                                <i class="fa-solid fa-lightbulb"
                                                                                    style="color: #fbbf24;"></i>
                                                                                Explanation:
                                                                            </strong>
                                                                            <p
                                                                                style="margin: 0; color: #1e40af; font-size: 14px; line-height: 1.5;">
                                                                                <%= expl %>
                                                                            </p>
                                                                        </div>
                                                                    </div>
                                                                    <% } %>
                                                            </div>
                                                            <% } %>
                        </div>

                        <script src="js/theme.js"></script>
                    </body>

                    </html>