<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Online Quiz</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>Login</h2>
        
        <% 
            String msg = request.getParameter("msg");
            if("registered".equals(msg)) { out.print("<div class='alert alert-success'>Registration successful. Please login.</div>"); }
            if("invalid".equals(msg)) { out.print("<div class='alert'>Invalid email or password.</div>"); }
            if("error".equals(msg)) { out.print("<div class='alert'>An error occurred. Please try again.</div>"); }
            if("exception".equals(msg)) { 
                String detail = request.getParameter("detail");
                String errorMsg = "⚠ Server Exception: " + (detail != null ? detail : "Check Tomcat console logs (catalina.out) for the exact error.");
                out.print("<div class='alert' style='color:red;font-weight:bold;'>" + errorMsg + "</div>"); 
            }
            if("dberror".equals(msg)) { out.print("<div class='alert' style='color:red;font-weight:bold;'>⚠ Database Connection Failed: MySQL may not be running, or password/port is incorrect.</div>"); }
        %>

        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit" class="btn">Login</button>
        </form>
        <br>
        <p>Don't have an account? <a href="register.jsp">Register here</a></p>
    </div>
</body>
</html>
