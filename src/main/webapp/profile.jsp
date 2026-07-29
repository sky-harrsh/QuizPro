<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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
    
    // Explicit fetch for profile details from request
    String email = (String) request.getAttribute("email");
    String createdAt = (String) request.getAttribute("createdAt");
    Integer totalQuizzes = (Integer) request.getAttribute("totalQuizzes");
    if(totalQuizzes == null) totalQuizzes = 0;
    Integer bestScore = (Integer) request.getAttribute("bestScore");
    if(bestScore == null) bestScore = 0;
    Double overallScorePercent = (Double) request.getAttribute("overallScorePercent");
    if(overallScorePercent == null) overallScorePercent = 0.0;
    
    int coreP = (Integer) request.getAttribute("catCore");
    int oopP = (Integer) request.getAttribute("catOop");
    int advP = (Integer) request.getAttribute("catAdv");
    int miscP = (Integer) request.getAttribute("catMisc");

    @SuppressWarnings("unchecked")
    List<Map<String, Object>> scoreHistory = (List<Map<String, Object>>) request.getAttribute("scoreHistory");
    String tipsJson = (String) request.getAttribute("tips");

    // Grade Calculation
    String grade = "D"; String badge = "💪 Just Getting Started"; String gColor = "#ef4444";
    if (overallScorePercent >= 90) { grade = "A+"; badge = "🏆 Java Master"; gColor = "#fbbf24"; }
    else if (overallScorePercent >= 75) { grade = "A"; badge = "⭐ Advanced Learner"; gColor = "#10b981"; }
    else if (overallScorePercent >= 60) { grade = "B"; badge = "📈 Good Progress"; gColor = "#3b82f6"; }
    else if (overallScorePercent >= 45) { grade = "C"; badge = "📚 Keep Studying"; gColor = "#f97316"; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= username %>'s Profile - QuizPro</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/themes.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .profile-container { max-width: 1000px; margin: 40px auto; padding: 0 20px; display: grid; gap: 24px; }
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
        .grid-3 { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
        @media (max-width: 768px) { .grid-2, .grid-3 { grid-template-columns: 1fr; } }

        .card { background: rgba(255,255,255,0.08) !important; border: 1px solid rgba(255,255,255,0.15) !important; border-radius: 12px; padding: 24px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }

        .avatar-lg {
            width: 100px; height: 100px; border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 3rem; font-weight: bold; color: white; margin: 0 auto 15px;
            background: linear-gradient(135deg, #667eea, #764ba2); box-shadow: 0 10px 15px rgba(102,126,234,0.3);
        }
        
        /* User info card text */
        .avatar-lg + h2 {
            color: #ffffff !important;
            font-size: 22px;
            font-weight: 600;
        }
        .avatar-lg + h2 + p {
            color: rgba(255, 255, 255, 0.75) !important;
        }
        .avatar-lg + h2 + p small {
            color: rgba(255, 255, 255, 0.60) !important;
            font-size: 13px;
        }

        /* Metric cards */
        .metric-box {
            background: rgba(255, 255, 255, 0.10) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
            border-radius: 12px;
            padding: 16px;
            text-align: center;
        }

        .metric-box div:first-child {
            color: #ffffff !important;
            font-size: 28px;
            font-weight: 700;
        }

        .metric-box div:last-child {
            color: rgba(255, 255, 255, 0.65) !important;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Override specific metric colors */
        .metric-box:nth-child(1) div:first-child { color: #67e8f9 !important; }
        .metric-box:nth-child(2) div:first-child { color: #86efac !important; }
        .metric-box:nth-child(3) div:first-child { color: #fbbf24 !important; }
        
        /* Grade Card */
        #grade-card.card {
            background: rgba(255, 255, 255, 0.08) !important;
            border: 1px solid rgba(255, 255, 255, 0.15) !important;
        }

        #grade-card h3 {
            color: rgba(255, 255, 255, 0.75) !important;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        #grade-card #badge-title {
            color: #ffffff !important;
            font-size: 20px;
            font-weight: 600;
        }

        #grade-card p {
            color: rgba(255, 255, 255, 0.65) !important;
            font-size: 14px;
        }
        
        .grade-ring {
            width: 120px; height: 120px; border-radius: 50%; border: 8px solid rgba(255, 255, 255, 0.15); display: flex; align-items: center; justify-content: center;
            font-size: 3rem; font-weight: 800; margin: 0 auto;
            animation: spin-grade 1s ease-out forwards;
        }
        @keyframes spin-grade { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }

        /* Section Headings */
        .card h3 {
            color: #ffffff !important;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 16px;
        }

        /* Tips */
        .tip-card {
            background: rgba(255, 255, 255, 0.07) !important;
            border-radius: 10px;
            padding: 14px 16px;
            color: rgba(255, 255, 255, 0.88) !important;
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 15px;
            border-left: 4px solid transparent;
        }

        .tip-high   { border-left-color: #f87171 !important; }
        .tip-medium { border-left-color: #fbbf24 !important; }
        .tip-low    { border-left-color: #34d399 !important; }

        .tip-card strong {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }
        .tip-high strong   { color: #f87171; }
        .tip-medium strong { color: #fbbf24; }
        .tip-low strong    { color: #34d399; }

        /* Table */
        .history-table {
            width: 100%;
            border-collapse: collapse;
            color: rgba(255, 255, 255, 0.95) !important;
            margin-top: 15px;
        }

        .history-table thead tr {
            background: rgba(255, 255, 255, 0.12) !important;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
        }

        .history-table thead th {
            color: #ffffff !important;
            font-weight: 600;
            font-size: 13px;
            padding: 14px 16px;
            text-align: left;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            cursor: pointer;
            position: relative;
        }

        .history-table thead th:hover {
            background: rgba(255, 255, 255, 0.08);
        }

        .history-table tbody tr {
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            transition: background 0.2s;
        }

        .history-table tbody tr:hover {
            background: rgba(255, 255, 255, 0.08) !important;
        }

        .history-table tbody td {
            color: rgba(255, 255, 255, 0.90) !important;
            font-size: 14px;
            padding: 14px 16px;
        }

        /* Date column slightly muted */
        .history-table tbody td:first-child {
            color: rgba(255, 255, 255, 0.70) !important;
            font-size: 13px;
            font-family: monospace;
        }

        /* Category column accent color */
        .history-table tbody td:nth-child(2) {
            color: #a78bfa !important;
            font-weight: 500;
        }

        /* Score column */
        .history-table tbody td:nth-child(3) {
            color: #67e8f9 !important;
            font-weight: 500;
        }

        /* Percentage column */
        .history-table tbody td:nth-child(4) {
            color: #86efac !important;
            font-weight: 600;
        }

        .g-badge { padding: 2px 8px; border-radius: 12px; font-weight:bold; font-size: 0.85rem; color: white; }
        .g-Ap { background: #fbbf24; }
        .g-A { background: #10b981; }
        .g-B { background: #3b82f6; }
        .g-C { background: #f97316; }
        .g-D { background: #ef4444; }
    </style>
</head>
<body>
    <div class="nav">
        <a href="dashboard.jsp" title="Go to Dashboard" style="text-decoration: none; color: inherit;">
            <h2 style="margin:0;"><i class="fa-solid fa-graduation-cap"></i> QuizPro</h2>
        </a>
        <div class="navbar-right">
    <button onclick="cycleTheme()" id="theme-btn" class="btn" style="background:transparent; border:1px solid rgba(255,255,255,0.3); padding: 5px 15px; border-radius: 5px; color: inherit; font-weight: bold;">🎨 Dark</button>
    <a href="LogoutServlet"><i class="fa-solid fa-sign-out-alt"></i> Logout</a>
    <div class="profile-circle-wrapper">
        <a href="ProfileServlet" class="profile-circle" title="View Profile">
            <%= initial %>
        </a>
        <div class="profile-username-tag"><%= username %></div>
    </div>
</div></div>

    <div class="profile-container">
        <!-- Section 1 & 3: Info & Grade -->
        <div class="grid-2">
            <div class="card" style="text-align: center;">
                <div class="avatar-lg"><%= username.substring(0,1).toUpperCase() %></div>
                <h2 style="margin:0 0 5px 0;"><%= username %></h2>
                <p style="color: #64748b; margin: 0 0 20px 0;">🎙 <%= email %> <br> <small>Member since: <%= createdAt != null ? createdAt : "Recently" %></small></p>
                <div class="grid-3">
                    <div class="metric-box">
                        <div style="font-size:1.5rem; font-weight:bold; color:var(--primary);"><%= totalQuizzes %></div>
                        <div style="font-size:0.85rem; color:#64748b;">Quizzes</div>
                    </div>
                    <div class="metric-box">
                        <div style="font-size:1.5rem; font-weight:bold; color:#10b981;"><%= bestScore %>%</div>
                        <div style="font-size:0.85rem; color:#64748b;">Best</div>
                    </div>
                    <div class="metric-box">
                        <div style="font-size:1.5rem; font-weight:bold; color:#f59e0b;"><%= String.format("%.0f", overallScorePercent) %>%</div>
                        <div style="font-size:0.85rem; color:#64748b;">Average</div>
                    </div>
                </div>
            </div>

            <div class="card" id="grade-card" style="text-align: center; display: flex; flex-direction: column; justify-content: center;" data-color="<%= gColor %>">
                <h3 style="margin-top: 0;">Overall Performance Grade</h3>
                <div class="grade-ring" id="grade-ring" style="transform: rotate(360deg);"><div style="animation: spin-grade 1s reverse forwards;"><%= grade %></div></div>
                <h2 id="badge-title" style="margin: 15px 0 5px;"><%= badge %></h2>
                <p style="color: #64748b; margin:0;">Based on <%= String.format("%.1f", overallScorePercent) %>% lifetime average.</p>
            </div>
        </div>

        <!-- Section 2 & 5: Charts -->
        <div class="grid-2">
            <div class="card">
                <h3>Score History Trend</h3>
                <canvas id="lineChart" height="200"></canvas>
            </div>
            <div class="card">
                <h3>Category Mastery Radar</h3>
                <canvas id="radarChart" height="200"></canvas>
            </div>
        </div>
        
        <div class="card">
            <h3>Average Score by Category</h3>
            <canvas id="barChart" height="80"></canvas>
        </div>

        <!-- Section 4: Tips -->
        <div class="card" style="background: rgba(248, 250, 252, 0.95);">
            <h3><i class="fa-solid fa-robot" style="color: #3b82f6;"></i> AI Personalized Study Tips</h3>
            <div id="tipsContainer" data-tips='<%= tipsJson.replace("'", "&#39;") %>'>
                <!-- Parsed via JS below -->
            </div>
        </div>

        <!-- Section 6: History Table -->
        <div class="card">
            <h3>Recent Quiz History</h3>
            <div style="overflow-x: auto;">
                <table class="history-table" id="histTable">
                    <thead>
                        <tr>
                            <th onclick="sortTable(0)">Date <i class="fa-solid fa-sort"></i></th>
                            <th onclick="sortTable(1)">Category <i class="fa-solid fa-sort"></i></th>
                            <th onclick="sortTable(2)">Score <i class="fa-solid fa-sort"></i></th>
                            <th onclick="sortTable(3)">Percentage <i class="fa-solid fa-sort"></i></th>
                            <th>Grade</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> row : scoreHistory) { 
                            int p = (Integer) row.get("percent");
                            String g = "D"; String cClass = "g-D";
                            if(p>=90){g="A+"; cClass="g-Ap";} else if(p>=75){g="A"; cClass="g-A";} else if(p>=60){g="B"; cClass="g-B";} else if(p>=45){g="C"; cClass="g-C";}
                        %>
                        <tr>
                            <td><%= row.get("date") %></td>
                            <td style="text-transform: capitalize;"><%= row.get("category") %></td>
                            <td><%= row.get("score") %> / <%= row.get("total") %></td>
                            <td><%= p %>%</td>
                            <td><span class="g-badge <%= cClass %>"><%= g %></span></td>
                        </tr>
                        <% } %>
                        <% if(scoreHistory.isEmpty()) { %>
                        <tr><td colspan="5" style="text-align:center; color:#64748b;">No quizzes taken yet.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <% 
        StringBuilder dates = new StringBuilder("[");
        StringBuilder scores = new StringBuilder("[");
        for(int i = scoreHistory.size()-1; i >= 0; i--) {
            dates.append("\"").append(scoreHistory.get(i).get("date").toString().substring(0,10)).append("\"");
            scores.append(scoreHistory.get(i).get("percent"));
            if(i > 0) { dates.append(","); scores.append(","); }
        }
        dates.append("]"); scores.append("]");
        
        boolean improving = true;
        if (scoreHistory.size() >= 2) {
            int first = (Integer)scoreHistory.get(scoreHistory.size()-1).get("percent");
            int last = (Integer)scoreHistory.get(0).get("percent");
            if (last < first) improving = false;
        }
    %>

    <!-- Chart Config -->
    <div id="metricData" style="display:none;" 
         data-dates='<%= dates.toString() %>' 
         data-scores='<%= scores.toString() %>' 
         data-improving='<%= improving ? "true" : "false" %>' 
         data-core='<%= coreP %>' data-oop='<%= oopP %>' data-adv='<%= advP %>' data-misc='<%= miscP %>'></div>

    <script>
        const md = document.getElementById('metricData');
        const dtSet = JSON.parse(md.getAttribute('data-dates'));
        const scSet = JSON.parse(md.getAttribute('data-scores'));
        const isBetter = md.getAttribute('data-improving') === 'true';
        const dCor = parseInt(md.getAttribute('data-core'));
        const dOop = parseInt(md.getAttribute('data-oop'));
        const dAdv = parseInt(md.getAttribute('data-adv'));
        const dMis = parseInt(md.getAttribute('data-misc'));

        // Inject colors dynamically avoiding IDE CSS lints
        const gc = document.getElementById('grade-card').getAttribute('data-color');
        document.getElementById('grade-ring').style.color = gc;
        document.getElementById('grade-ring').style.borderTopColor = gc;
        document.getElementById('badge-title').style.color = gc;

        const lineCtx = document.getElementById('lineChart');
        new Chart(lineCtx, {
            type: 'line',
            data: {
                labels: dtSet,
                datasets: [{
                    label: 'Score Percentage',
                    data: scSet,
                    borderColor: isBetter ? "#10b981" : "#ef4444",
                    backgroundColor: isBetter ? "rgba(16, 185, 129, 0.1)" : "rgba(239, 68, 68, 0.1)",
                    borderWidth: 3, fill: true, tension: 0.3
                }]
            },
            options: {
                scales: { 
                    y: { 
                        min: 0, max: 100,
                        ticks: { color: 'rgba(255,255,255,0.7)', font: { size: 11 } },
                        grid: { color: 'rgba(255,255,255,0.08)' }
                    },
                    x: {
                        ticks: { color: 'rgba(255,255,255,0.7)', font: { size: 11 }, maxRotation: 45 },
                        grid: { color: 'rgba(255,255,255,0.08)' }
                    }
                },
                plugins: {
                    legend: {
                        labels: { color: 'rgba(255,255,255,0.9)', font: { size: 13 } }
                    }
                }
            }
        });

        const barCtx = document.getElementById('barChart');
        new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: ['Core Java', 'OOP', 'Advanced', 'Misc'],
                datasets: [{
                    label: 'Average %',
                    data: [dCor, dOop, dAdv, dMis],
                    backgroundColor: ['#3b82f6', '#10b981', '#ef4444', '#8b5cf6'],
                    borderRadius: 6
                }]
            },
            options: { 
                scales: { 
                    y: { 
                        min: 0, max: 100,
                        ticks: { color: 'rgba(255,255,255,0.7)', font: { size: 11 } },
                        grid: { color: 'rgba(255,255,255,0.08)' }
                    },
                    x: {
                        ticks: { color: 'rgba(255,255,255,0.7)', font: { size: 11 } },
                        grid: { color: 'rgba(255,255,255,0.08)' }
                    }
                }, 
                plugins: { legend: { display: false } } 
            }
        });

        const radarCtx = document.getElementById('radarChart');
        new Chart(radarCtx, {
            type: 'radar',
            data: {
                labels: ['Core Java', 'OOP', 'Advanced', 'Misc'],
                datasets: [{
                    label: 'Mastery',
                    data: [dCor, dOop, dAdv, dMis],
                    backgroundColor: 'rgba(99, 102, 241, 0.2)',
                    borderColor: '#6366f1', pointBackgroundColor: '#6366f1', borderWidth: 2
                }]
            },
            options: { 
                scales: { 
                    r: { 
                        min: 0, max: 100, 
                        ticks: { color: 'rgba(255,255,255,0.6)', backdropColor: 'transparent', font: { size: 10 } },
                        angleLines: { color: 'rgba(255,255,255,0.15)' },
                        grid: { color: 'rgba(255,255,255,0.15)' },
                        pointLabels: { color: 'rgba(255,255,255,0.95)', font: { size: 13, weight: '500' } }
                    } 
                },
                plugins: {
                    legend: {
                        labels: { color: 'rgba(255,255,255,0.9)', font: { size: 13 } }
                    }
                }
            }
        });

        // Parse AI Tips safely by passing via dataset attribute instead of template literal
        const tc = document.getElementById('tipsContainer');
        let tipsText = tc.getAttribute('data-tips');
        try {
            const list = JSON.parse(tipsText);
            if(list.length === 0) tc.innerHTML = '<p style="color: #64748b;">Take a few quizzes and come back for AI-generated personalized study tips!</p>';
            list.forEach(item => {
                let pClass = 'tip-low';
                if(item.priority === 'high') pClass = 'tip-high';
                else if(item.priority === 'medium') pClass = 'tip-medium';
                tc.innerHTML += `<div class="tip-card ${pClass}"><strong>[${item.priority.toUpperCase()}]</strong> ${item.tip}</div>`;
            });
        } catch(e) {
            tc.innerHTML = '<div class="tip-card tip-medium">Review your lowest scoring category notes to improve your average!</div>';
        }

        // Table Sort Logic
        let sortDir = [true, true, true, true];
        function sortTable(n) {
            let table = document.getElementById("histTable");
            let rows = Array.from(table.rows).slice(1);
            let dir = sortDir[n];
            
            rows.sort((a, b) => {
                let x = a.cells[n].innerText;
                let y = b.cells[n].innerText;
                if(n === 2 || n === 3) {
                    x = parseFloat(x); y = parseFloat(y);
                }
                return dir ? (x > y ? 1 : -1) : (x < y ? 1 : -1);
            });
            sortDir[n] = !dir;
            table.tBodies[0].append(...rows);
        }
    </script>
    <script src="js/theme.js"></script>
</body>
</html>
