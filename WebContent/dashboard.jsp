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
    <title>Dashboard - Online Quiz</title>
    <link rel="stylesheet" href="css/style.css">
    <!-- Load FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="nav">
        <h2><i class="fa-solid fa-graduation-cap"></i> QuizPro</h2>
        <div>
            <span>Welcome, <%= session.getAttribute("username") %>!</span>
            <a href="LogoutServlet"><i class="fa-solid fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>
    
    <div class="container text-center">
        <h2>Select a Quiz Category</h2>
        <p style="color: var(--text-muted); margin-bottom: 30px;">Choose a topic below to test your Java knowledge.</p>
        
        <div class="category-grid">
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
</body>
</html>
