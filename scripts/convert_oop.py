import os
import io

navbar_html = """
<div class="nav" style="padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; background: #fff; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <a href="dashboard.jsp" title="Go to Dashboard" style="text-decoration: none; color: inherit;">
        <h2 style="margin:0;"><i class="fa-solid fa-graduation-cap"></i> QuizPro</h2>
    </a>
    <div style="display: flex; align-items: center; gap: 15px;">
        <a href="ProfileServlet" title="Go to Profile" style="text-decoration:none; display:flex; align-items:center; justify-content:center; width:35px; height:35px; border-radius:50%; background:linear-gradient(135deg, #667eea, #764ba2); color:white; font-weight:bold; box-shadow:0 2px 4px rgba(0,0,0,0.2);">
            <%= session.getAttribute("username") != null ? ((String)session.getAttribute("username")).substring(0,1).toUpperCase() : "U" %>
        </a>
        <button onclick="cycleTheme()" id="theme-btn" class="btn" style="background:transparent; border:1px solid #ddd; padding: 5px 15px; border-radius: 5px; color: inherit; font-weight: bold;">🎨 Dark</button>
        <span style="display: flex; align-items: center;">Welcome, <%= session.getAttribute("username") %>!</span>
        <a href="LogoutServlet" style="text-decoration: none; color: #e53e3e;"><i class="fa-solid fa-sign-out-alt"></i> Logout</a>
    </div>
</div>
"""

tabs_css = """
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
.notes-container { max-width: 1200px; margin: 0 auto; padding: 20px; }
.take-quiz-btn { display: block; text-align: center; margin: 40px auto; padding: 15px 30px; background: #4f46e5; color: white; border-radius: 30px; text-decoration: none; font-size: 1.2rem; font-weight: bold; width: fit-content; transition: background 0.3s; }
.take-quiz-btn:hover { background: #4338ca; }
</style>
"""

tabs_html = """<div class="category-tabs">
    <a href="NotesServlet?category=core"     class="tab-btn">☕ Core Java</a>
    <a href="NotesServlet?category=oop"      class="tab-btn active">🧩 OOP Concepts</a>
    <a href="NotesServlet?category=advanced" class="tab-btn">⚡ Advanced Java</a>
    <a href="NotesServlet?category=misc"     class="tab-btn">📦 Miscellaneous</a>
</div>"""

def convert_oop():
    with open('c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/oop-notes.jsp', 'r', encoding='utf-8') as f:
        oop_content = f.read()

    # remove the existing page directive at the top
    oop_content = oop_content.replace('<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>', '', 1)

    full_html = f"""<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {{
        response.sendRedirect("login.jsp");
        return;
    }}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>OOP Concepts Notes - QuizPro</title>
    <link rel="stylesheet" href="css/notes.css">
    <link rel="stylesheet" href="css/themes.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    {tabs_css}
</head>
<body>
{navbar_html}
{tabs_html}

<div class="notes-container">
{oop_content}
</div>

<a href="QuizServlet?category=oop" class="take-quiz-btn">
    Ready? Take the OOP Concepts Quiz &rarr;
</a>

<script src="js/theme.js"></script>
</body>
</html>"""

    with open('c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/notes-oop.jsp', 'w', encoding='utf-8') as f:
        f.write(full_html)

convert_oop()
