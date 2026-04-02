<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Online Quiz</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>Register</h2>
        
        <% 
            String msg = request.getParameter("msg");
            if("error".equals(msg)) { out.print("<div class='alert'>Registration failed. Email or Username might be taken.</div>"); }
            if("exception".equals(msg)) { out.print("<div class='alert'>An error occurred. Please try again.</div>"); }
        %>

        <form action="RegisterServlet" method="post">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit" class="btn">Register</button>
        </form>
        <br>
        <p>Already have an account? <a href="login.jsp">Login here</a></p>
    </div>
</body>
</html>
