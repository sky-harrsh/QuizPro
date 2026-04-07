<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% if (session.getAttribute("userId")==null) { response.sendRedirect("login.jsp"); return; } %>
<%
    String msg = request.getParameter("msg");
    boolean showError = "error".equals(msg);
%>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Dashboard - Online Quiz</title>
            <link rel="stylesheet" href="css/style.css">
            <!-- Theme System Styles and Icons -->
            <link rel="stylesheet" href="css/themes.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                .dashboard-layout-wrapper {
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    gap: 24px;
                }

                .study-notes-hero {
                    width: 100%;
                    max-width: 520px;
                    min-height: 140px;
                    background: linear-gradient(135deg, #667eea, #764ba2) !important;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    text-align: center;
                    border: none;
                    transition: transform 0.3s ease, box-shadow 0.3s ease;
                    text-decoration: none;
                    box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
                    border-radius: 12px;
                    padding: 20px;
                }

                .study-notes-hero:hover,
                .flashcard-hero:hover {
                    transform: scale(1.03) !important;
                    box-shadow: 0 15px 30px rgba(118, 75, 162, 0.5) !important;
                }

                .flashcard-hero {
                    width: 100%;
                    max-width: 520px;
                    min-height: 140px;
                    background: linear-gradient(135deg, #f093fb, #f5576c) !important;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    text-align: center;
                    border: none;
                    transition: transform 0.3s ease, box-shadow 0.3s ease;
                    text-decoration: none;
                    box-shadow: 0 10px 20px rgba(240, 147, 251, 0.3);
                    border-radius: 12px;
                    padding: 20px;
                }

                .study-notes-hero .category-icon,
                .flashcard-hero .category-icon {
                    color: white !important;
                    font-size: 2.5rem;
                    margin-bottom: 12px;
                }

                .quiz-cards-wrapper {
                    display: flex;
                    flex-direction: row;
                    gap: 16px;
                    justify-content: center;
                    width: 100%;
                    flex-wrap: wrap;
                    /* Ensures safe overflow on small screens before breakpoint */
                }

                @media (max-width: 600px) {
                    .quiz-cards-wrapper {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 16px;
                    }
                }
            </style>
        </head>

        <body class="dashboard-body">
            <div class="nav">
                <a href="dashboard.jsp" title="Go to Dashboard" style="text-decoration: none; color: inherit;">
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

            <div class="container text-center">
                <% if (showError) { 
                    String detail = request.getParameter("detail");
                %>
                <div id="errorBanner" style="
                    background: #fee2e2;
                    color: #991b1b;
                    padding: 12px 20px;
                    border-radius: 8px;
                    margin: 0 auto 20px;
                    max-width: 680px;
                    text-align: center;
                    font-size: 14px;
                    border: 1px solid #fca5a5;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;
                    gap: 4px;
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                ">
                    <div style="display: flex; align-items: center; gap: 8px; font-weight: 600;">
                        &#9888; Action Failed
                        <span onclick="document.getElementById('errorBanner').remove()"
                            style="cursor:pointer; margin-left:8px; font-size:18px; opacity: 0.7;">
                            &times;
                        </span>
                    </div>
                    <% if (detail != null && !detail.isEmpty()) { %>
                        <div style="font-size: 12px; opacity: 0.8; font-family: monospace; background: rgba(255,255,255,0.5); padding: 4px 8px; border-radius: 4px; margin-top: 4px;">
                            Error: <%= detail %>
                        </div>
                    <% } else { %>
                        <div style="font-size: 13px; opacity: 0.9;">Please verify your connection or try again.</div>
                    <% } %>
                </div>
                <script>
                    // Clean ?msg=error from URL without page reload
                    if (window.history && window.history.replaceState) {
                        window.history.replaceState(
                            {}, document.title,
                            window.location.pathname
                        );
                    }
                    // Auto-hide after 4 seconds
                    setTimeout(() => {
                        const banner = document.getElementById('errorBanner');
                        if (banner) banner.style.display = 'none';
                    }, 4000);
                </script>
                <% } %>
                <h2>Select a Quiz Category</h2>
                <p style="color: var(--text-muted); margin-bottom: 30px;">Choose a topic below to test your Java
                    knowledge.</p>

                <div class="dashboard-layout-wrapper">
                    <div
                        style="display:flex; flex-direction:row; gap:16px; width:100%; justify-content:center; flex-wrap:wrap;">
                        <!-- Hero Card 1 -->
                        <a href="NotesServlet?category=core" class="category-card study-notes-hero"
                            style="flex: 1; min-width: 250px;">
                            <i class="fa-solid fa-book-open category-icon"></i>
                            <div
                                style="display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 8px;">
                                <span class="category-title"
                                    style="color: white; font-size: 1.5rem; display: block; margin: 0;">📚 Study
                                    Notes</span>
                                <span
                                    style="color: rgba(255,255,255,0.9); font-size: 0.95rem; font-weight: normal; line-height: 1.4;">Full
                                    engineering-level Java notes with diagrams & dry runs</span>
                            </div>
                        </a>

                        <!-- Hero Card 2 -->
                        <a href="flashcards.jsp" class="category-card flashcard-hero"
                            style="flex: 1; min-width: 250px;">
                            <i class="fa-solid fa-layer-group category-icon"></i>
                            <div
                                style="display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 8px;">
                                <span class="category-title"
                                    style="color: white; font-size: 1.5rem; display: block; margin: 0;">🃏 Flashcard
                                    Revision</span>
                                <span
                                    style="color: rgba(255,255,255,0.9); font-size: 0.95rem; font-weight: normal; line-height: 1.4;">Quick-fire
                                    revision of all Java topics</span>
                            </div>
                        </a>
                    </div>

                    <p style="color: var(--text-muted, #64748b); margin: 10px 0 0 0; font-size: 0.95rem;">Or jump
                        straight to a quiz:</p>

                    <!-- Quiz Cards -->
                    <div class="quiz-cards-wrapper">
                        <a href="QuizServlet?category=core" class="category-card">
                            <i class="fa-brands fa-java category-icon" style="color: #f89820;"></i>
                            <span class="category-title">Core Java</span>
                        </a>
                        <a href="QuizServlet?category=oop" class="category-card">
                            <i class="fa-solid fa-cubes category-icon" style="color: #3498db;"></i>
                            <span class="category-title">OOP Concepts</span>
                        </a>
                        <a href="QuizServlet?category=advanced" class="category-card">
                            <i class="fa-solid fa-bolt category-icon" style="color: #e74c3c;"></i>
                            <span class="category-title">Advanced Java</span>
                        </a>
                        <a href="QuizServlet?category=misc" class="category-card">
                            <i class="fa-solid fa-layer-group category-icon" style="color: #9b59b6;"></i>
                            <span class="category-title">Miscellaneous</span>
                        </a>
                    </div>
                </div>
            </div>

            <script src="js/theme.js"></script>
        </body>

        </html>