<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - QuizPro</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: linear-gradient(135deg, #0a0a2e 0%, #1a1a4e 40%, #0d3b6e 70%, #1a5276 100%);
            min-height: 100vh;
            font-family: 'Inter', 'Segoe UI', sans-serif;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        #particles {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            z-index: 0;
            pointer-events: none;
        }
        .float-kw {
            position: fixed;
            font-family: 'Courier New', monospace;
            color: rgba(167, 139, 250, 0.06);
            font-size: 22px;
            font-weight: bold;
            pointer-events: none;
            z-index: 0;
            animation: floatKw 25s linear infinite;
        }
        @keyframes floatKw {
            0%   { transform: translateY(110vh); opacity: 0; }
            5%   { opacity: 1; }
            95%  { opacity: 1; }
            100% { transform: translateY(-100px); opacity: 0; }
        }
        @keyframes floatParticle {
            0%   { transform: translateY(100vh) rotate(0deg); opacity: 0; }
            10%  { opacity: 0.4; }
            90%  { opacity: 0.4; }
            100% { transform: translateY(-100px) rotate(720deg); opacity: 0; }
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .login-wrapper {
            position: relative;
            z-index: 10;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 24px;
            padding: 48px 44px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
            animation: fadeInUp 0.7s ease forwards;
        }
        .logo-area {
            text-align: center;
            margin-bottom: 28px;
        }
        .logo-icon {
            width: 64px; height: 64px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 18px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: white;
            margin-bottom: 12px;
            box-shadow: 0 8px 20px rgba(102,126,234,0.4);
        }
        .logo-text {
            font-size: 24px;
            font-weight: 700;
            color: white;
            letter-spacing: -0.5px;
        }
        .card-title {
            font-size: 28px;
            font-weight: 600;
            color: white;
            text-align: center;
            margin-bottom: 6px;
        }
        .card-subtitle {
            font-size: 14px;
            color: rgba(255,255,255,0.55);
            text-align: center;
            margin-bottom: 32px;
        }
        .form-group { margin-bottom: 18px; }
        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 500;
            color: rgba(255,255,255,0.8);
            margin-bottom: 8px;
        }
        .login-input {
            width: 100%;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 12px;
            padding: 14px 16px;
            color: white;
            font-size: 15px;
            outline: none;
            transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
        }
        .login-input:focus {
            border-color: rgba(102,126,234,0.8);
            background: rgba(255,255,255,0.12);
            box-shadow: 0 0 0 3px rgba(102,126,234,0.15);
        }
        .login-input::placeholder { color: rgba(255,255,255,0.35); }
        .login-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-top: 8px;
        }
        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102,126,234,0.5);
        }
        .login-btn:active { transform: translateY(0); }
        .register-link {
            text-align: center;
            margin-top: 22px;
            font-size: 14px;
            color: rgba(255,255,255,0.6);
        }
        .register-link a {
            color: #a78bfa;
            text-decoration: none;
            font-weight: 500;
        }
        .register-link a:hover { text-decoration: underline; }
        .alert-glass {
            background: rgba(239,68,68,0.15);
            border: 1px solid rgba(239,68,68,0.4);
            border-radius: 10px;
            padding: 12px 16px;
            color: #fca5a5;
            font-size: 14px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
    </style>
</head>
<body>
    <div id="particles"></div>

    <div class="login-wrapper">
        <div class="login-card">
            <div class="logo-area">
                <div class="logo-icon"><i class="fa-solid fa-graduation-cap"></i></div>
                <div class="logo-text">QuizPro</div>
            </div>

            <h1 class="card-title">Create Account</h1>
            <p class="card-subtitle">Join QuizPro and master Java today</p>

            <%
                String msg = request.getParameter("msg");
                if ("error".equals(msg)) {
            %>
            <div class="alert-glass"><i class="fa-solid fa-triangle-exclamation"></i> Registration failed. Email or username may already be taken.</div>
            <% } else if ("exception".equals(msg)) { %>
            <div class="alert-glass"><i class="fa-solid fa-triangle-exclamation"></i> An error occurred. Please try again.</div>
            <% } %>

            <form action="RegisterServlet" method="post">
                <div class="form-group">
                    <label class="form-label" for="username">Username</label>
                    <input type="text" id="username" name="username" class="login-input" placeholder="Your name" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="email">Email</label>
                    <input type="email" id="email" name="email" class="login-input" placeholder="you@example.com" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="login-input" placeholder="••••••••" required>
                </div>
                <button type="submit" class="login-btn"><i class="fa-solid fa-user-plus"></i> Create Account</button>
            </form>

            <div class="register-link">
                Already have an account? <a href="login.jsp">Login here</a>
            </div>
        </div>
    </div>

    <script>
        (function createParticles() {
            const container = document.getElementById('particles');
            const colors = ['#667eea','#764ba2','#f093fb','#4facfe','#00f2fe','#a78bfa'];
            for (let i = 0; i < 60; i++) {
                const p = document.createElement('div');
                p.style.cssText = `
                    position:fixed;
                    width:${Math.random()*6+2}px;
                    height:${Math.random()*6+2}px;
                    background:${colors[Math.floor(Math.random()*colors.length)]};
                    border-radius:50%;
                    left:${Math.random()*100}vw;
                    top:${Math.random()*100}vh;
                    opacity:${Math.random()*0.6+0.1};
                    animation:floatParticle ${Math.random()*20+10}s linear infinite;
                    animation-delay:${Math.random()*-20}s;
                    pointer-events:none;
                `;
                container.appendChild(p);
            }
        })();

        (function createKeywords() {
            const keywords = ['class','void','public','static','import','extends','new','return','interface','throws','final','abstract','try','catch','super'];
            const container = document.getElementById('particles');
            keywords.forEach(kw => {
                const el = document.createElement('div');
                el.className = 'float-kw';
                el.textContent = kw;
                el.style.left = (Math.random() * 90 + 5) + 'vw';
                el.style.animationDuration = (Math.random() * 18 + 18) + 's';
                el.style.animationDelay = (Math.random() * -25) + 's';
                el.style.fontSize = (Math.random() * 14 + 16) + 'px';
                container.appendChild(el);
            });
        })();
    </script>
</body>
</html>
