<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Miscellaneous Notes - QuizPro</title>
    <link rel="stylesheet" href="css/notes.css">
    <link rel="stylesheet" href="css/themes.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
<style>
.category-tabs {
    display: flex;
    justify-content: center;
    gap: 15px;
    margin: 30px 0;
    flex-wrap: wrap;
}
.tab-btn {
    padding: 12px 25px;
    border-radius: 30px;
    background: #f8fafc;
    color: #475569;
    text-decoration: none;
    font-weight: 600;
    border: 2px solid transparent;
    transition: all 0.2s;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}
.tab-btn:hover { background: #f1f5f9; transform: translateY(-2px); }
.tab-btn.active { background: #e0e7ff; color: #4338ca; border-color: #4338ca; }
.notes-container { max-width: 900px; margin: 0 auto; padding: 20px; }
.chapter-card { background: var(--bg-card, white); color: var(--text-color, #1e293b); border-radius: 8px; padding: 25px; margin-bottom: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
.chapter-title { color: var(--text-color, #1e293b); border-bottom: 2px solid var(--border-color, #e2e8f0); padding-bottom: 10px; margin-top: 0; }
pre, code { background: #1e293b; color: #f8fafc; padding: 10px; border-radius: 5px; overflow-x: auto; font-family: monospace; display: block;}
.take-quiz-btn { display: block; text-align: center; margin: 40px auto; padding: 15px 30px; background: #4f46e5; color: white; border-radius: 30px; text-decoration: none; font-size: 1.2rem; font-weight: bold; width: fit-content; transition: background 0.3s; }
.take-quiz-btn:hover { background: #4338ca; }
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

<div class="category-tabs">
    <a href="NotesServlet?category=core"     class="tab-btn ">☕ Core Java</a>
    <a href="NotesServlet?category=oop"      class="tab-btn ">🧩 OOP Concepts</a>
    <a href="NotesServlet?category=advanced" class="tab-btn ">⚡ Advanced Java</a>
    <a href="NotesServlet?category=misc"     class="tab-btn active">📦 Miscellaneous</a>
</div>

<div class="notes-container">

<div class="chapter-card">
    <h2 class="chapter-title">Miscellaneous Topics in Java</h2>
    <p>This section covers supplementary topics that improve your engineering capability in Java but don't fall neatly into Core, OOP, or Advanced paths.</p>
    <ul>
        <li>Environment Variables & CLASSPATH configuration.</li>
        <li>Build tools like Maven and Gradle.</li>
        <li>Unit Testing with JUnit and Mockito.</li>
        <li>Regex (Regular Expressions) in Java (<code>java.util.regex</code>).</li>
        <li>Working with Dates and Times (<code>java.time.*</code>).</li>
    </ul>
    
    <h3>Regex Example</h3>
    <pre><code>import java.util.regex.*;
Pattern p = Pattern.compile("[a-zA-Z0-9]+@gmail\.com");
Matcher m = p.matcher("contact@gmail.com");
if (m.matches()) {
    System.out.println("Valid Gmail Address");
}</code></pre>
</div>

</div>

<a href="QuizServlet?category=misc" class="take-quiz-btn">
    Ready? Take the Miscellaneous Notes Quiz &rarr;
</a>

<script src="js/theme.js"></script>
</body>
</html>
