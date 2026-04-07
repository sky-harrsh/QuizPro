<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = "";
    String initial = "U";
    if (session.getAttribute("username") != null) {
        username = (String) session.getAttribute("username");
        if (!username.isEmpty()) {
            initial = String.valueOf(username.charAt(0)).toUpperCase();
        }
    }
%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Flashcard Revision - QuizPro</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/themes.css">
    <link rel="stylesheet" href="css/flashcards.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
</head>

<body class="dashboard-body flashcard-page">
    <div class="nav">
        <a href="dashboard.jsp" title="Go to Dashboard" style="text-decoration: none; color: inherit;">
            <h2 style="margin:0;"><i class="fa-solid fa-graduation-cap"></i> QuizPro</h2>
        </a>
        <div class="navbar-right">
    <button onclick="cycleTheme()" id="theme-btn" class="btn"
                    style="background:transparent; border:1px solid rgba(255,255,255,0.3); padding: 5px 15px; border-radius: 5px; color: inherit; font-weight: bold;">🎨
                    Dark</button>
    <a href="LogoutServlet"><i class="fa-solid fa-sign-out-alt"></i> Logout</a>
    <div class="profile-circle-wrapper">
        <a href="ProfileServlet" class="profile-circle" title="View Profile">
            <%= initial %>
        </a>
        <div class="profile-username-tag"><%= username %></div>
    </div>
</div></div>

        <div class="flashcard-container">

            <div class="flashcard-nav-bar">
                <div class="flashcard-category-selector">
                    <select id="cat-select" onchange="onCategoryChange()">
                        <option value="all">All Categories</option>
                        <option value="core">Core Java</option>
                        <option value="oop">OOP Concepts</option>
                        <option value="advanced">Advanced Java</option>
                        <option value="misc">Miscellaneous</option>
                    </select>
                </div>
                <div>
                    <button class="fc-btn" onclick="shuffleCards()"><i class="fa-solid fa-shuffle"></i>
                        Shuffle</button>
                    <button class="fc-btn" onclick="restartSession()"><i class="fa-solid fa-rotate-left"></i>
                        Restart</button>
                    <button class="fc-btn" onclick="toggleStats()"><i class="fa-solid fa-chart-bar"></i>
                        Stats</button>
                </div>
            </div>

            <div id="fc-loading" style="color: white; margin-top: 50px; font-size: 18px;">Loading Flashcards...
            </div>

            <div class="flashcard-progress-text" id="fc-progress-text">Card 0 of 0</div>
            <div class="flashcard-progress-bar">
                <div class="flashcard-progress-fill" id="fc-progress-fill"></div>
            </div>

            <div class="flashcard-scene" style="display:none;" onclick="flipCard()">
                <div class="flashcard">
                    <div class="flashcard-front">
                        <div id="fc-badge" class="flashcard-badge badge-core">Core</div>
                        <div id="fc-number" class="flashcard-number">1 / 10</div>

                        <div id="fc-question" class="flashcard-question">Loading Question...</div>
                        <div id="fc-code" class="flashcard-code" style="display:none;"></div>

                        <div class="flashcard-hint">👆 Click card to reveal answer</div>
                    </div>
                    <div class="flashcard-back">
                        <div id="fc-answer" class="flashcard-answer-correct"></div>
                        <div id="fc-options" class="flashcard-options"></div>
                        <div id="fc-explanation" class="flashcard-explanation"></div>

                        <div class="flashcard-difficulty">
                            <div class="diff-dot" id="diff-dot-1"
                                onclick="event.stopPropagation(); rateDifficulty(1)"></div>
                            <div class="diff-dot" id="diff-dot-2"
                                onclick="event.stopPropagation(); rateDifficulty(2)"></div>
                            <div class="diff-dot" id="diff-dot-3"
                                onclick="event.stopPropagation(); rateDifficulty(3)"></div>
                            <div class="diff-dot" id="diff-dot-4"
                                onclick="event.stopPropagation(); rateDifficulty(4)"></div>
                            <div class="diff-dot" id="diff-dot-5"
                                onclick="event.stopPropagation(); rateDifficulty(5)"></div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="flashcard-controls">
                <button class="fc-btn" id="btn-prev" onclick="prevCard()"><i class="fa-solid fa-arrow-left"></i>
                    Prev</button>
                <button class="fc-btn fc-btn-known" onclick="markKnown()"><i class="fa-solid fa-check"></i> Know
                    It</button>
                <button class="fc-btn" onclick="nextCard()">Next <i class="fa-solid fa-arrow-right"></i></button>
            </div>

        </div>

        <!-- Stats Panel -->
        <div class="stats-panel" id="stats-panel">
            <button class="stats-close" onclick="toggleStats()">&times;</button>
            <h2 style="margin-top:0;">Session Stats</h2>
            <div style="color: rgba(255,255,255,0.7); font-size: 14px; margin-bottom: 20px;">
                Elapsed Time: <strong id="session-time" style="color:white;">00:00</strong>
            </div>

            <div class="donut-chart" id="stats-donut">
                <div class="donut-inner">
                    <div style="font-size: 24px; font-weight: bold;" id="stats-donut-text">0%</div>
                    <div style="font-size: 12px; color: rgba(255,255,255,0.7);">Known</div>
                </div>
            </div>

            <div style="display: flex; justify-content: space-between; margin-bottom: 30px; margin-top: 20px;">
                <div style="text-align: center;">
                    <div style="font-size: 20px; color: #10b981; font-weight: bold;" id="stats-known">0</div>
                    <div style="font-size: 12px; color: rgba(255,255,255,0.7);">Known ✅</div>
                </div>
                <div style="text-align: center;">
                    <div style="font-size: 20px; color: #ef4444; font-weight: bold;" id="stats-unknown">0</div>
                    <div style="font-size: 12px; color: rgba(255,255,255,0.7);">Unknown 📚</div>
                </div>
            </div>

            <h3 style="border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">Categories Review</h3>
            <div id="stats-breakdown"
                style="margin-bottom: 30px; font-size: 14px; color: rgba(255,255,255,0.8); line-height: 1.8;"></div>

            <h3 style="border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">Keyboard Shortcuts
            </h3>
            <ul
                style="list-style: none; padding: 0; font-size: 14px; color: rgba(255,255,255,0.8); line-height: 2;">
                <li><kbd style="background:#334155; padding: 2px 6px; border-radius: 4px;">Space</kbd> Flip card
                </li>
                <li><kbd style="background:#334155; padding: 2px 6px; border-radius: 4px;">→</kbd> Next card</li>
                <li><kbd style="background:#334155; padding: 2px 6px; border-radius: 4px;">←</kbd> Previous card
                </li>
                <li><kbd style="background:#334155; padding: 2px 6px; border-radius: 4px;">Enter</kbd> Mark known
                </li>
            </ul>
        </div>

        <!-- Completion Overlay -->
        <div class="completion-overlay" id="completion-overlay">
            <div class="completion-card">
                <h2>🎉 Session Complete!</h2>

                <div class="completion-stat">
                    <span>Cards Reviewed:</span>
                    <strong id="c-total">0</strong>
                </div>
                <div class="completion-stat" style="color: #6ee7b7;">
                    <span>Known ✅:</span>
                    <strong id="c-known">0</strong>
                </div>
                <div class="completion-stat" style="color: #fca5a5;">
                    <span>Still Learning 📚:</span>
                    <strong id="c-unknown">0</strong>
                </div>
                <div class="completion-stat" style="color: #67e8f9; border-bottom: none;">
                    <span>Accuracy:</span>
                    <strong id="c-accuracy">0%</strong>
                </div>

                <div class="completion-buttons">
                    <button class="completion-btn completion-btn-primary" onclick="reviewUnknown()"><i
                            class="fa-solid fa-rotate-right"></i> Review Unknown Cards</button>
                    <button class="completion-btn" onclick="restartSession()"><i class="fa-solid fa-shuffle"></i>
                        Shuffle &amp; Restart</button>
                    <a href="#" id="c-quiz-link" class="completion-btn"><i class="fa-solid fa-pencil"></i> Take the
                        Quiz</a>
                    <a href="dashboard.jsp" class="completion-btn"><i class="fa-solid fa-home"></i> Back to
                        Dashboard</a>
                </div>
            </div>
        </div>

        <script src="js/flashcards.js"></script>
        <script src="js/theme.js"></script>
    </body>

</html>