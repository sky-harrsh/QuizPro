<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Online Quiz System - Home</title>
        <!-- Include global styles (excluding any overrides we replace here) -->
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/themes.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* Base landing body default */
            body {
                margin: 0;
                padding: 0;
                background: linear-gradient(135deg, #0a0a2e 0%, #1a1a4e 40%, #0d3b6e 70%, #1a5276 100%);
                min-height: 100vh;
                color: white;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                overflow-x: hidden;
                position: relative;
            }

            /* Abstract blobs */
            .blob {
                position: absolute;
                border-radius: 50%;
                filter: blur(80px);
                opacity: 0.15;
                z-index: 1;
                pointer-events: none;
            }

            .blob-1 {
                top: -10%;
                left: -10%;
                width: 400px;
                height: 400px;
                background: #764ba2;
            }

            .blob-2 {
                bottom: 10%;
                right: -5%;
                width: 500px;
                height: 500px;
                background: #667eea;
            }

            .blob-3 {
                top: 40%;
                left: 30%;
                width: 300px;
                height: 300px;
                background: #00b4d8;
            }

            /* Floating Java keywords */
            .floating-word {
                position: absolute;
                color: white;
                font-family: 'Consolas', monospace;
                opacity: 0;
                z-index: 2;
                pointer-events: none;
                animation: floatUp linear infinite;
            }

            @keyframes floatUp {
                0% {
                    transform: translateY(0px) rotate(0deg);
                    opacity: 0;
                }

                10% {
                    opacity: 0.06;
                }

                90% {
                    opacity: 0.06;
                }

                100% {
                    transform: translateY(-100vh) rotate(15deg);
                    opacity: 0;
                }
            }

            /* Card entrance */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(40px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Button shimmer */
            @keyframes shimmer {
                0% {
                    left: -100%;
                }

                100% {
                    left: 100%;
                }
            }

            /* Navbar Layout Overlay */
            .landing-nav {
                background: rgba(10, 10, 46, 0.9);
                backdrop-filter: blur(10px);
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 30px;
                position: relative;
                z-index: 50;
            }

            .landing-nav h2 {
                margin: 0;
                color: white;
                display: flex;
                align-items: center;
                gap: 10px;
                font-weight: bold;
            }

            .landing-nav-links {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .landing-nav a.btn {
                color: white;
                border: 1px solid rgba(255, 255, 255, 0.3);
                background: transparent;
                transition: all 0.2s;
            }

            .landing-nav a.btn:hover {
                background: rgba(255, 255, 255, 0.1);
            }

            .landing-nav .theme-btn {
                background: transparent;
                border: 1px solid rgba(255, 255, 255, 0.3);
                padding: 8px 16px;
                border-radius: 5px;
                color: white;
                font-weight: bold;
                cursor: pointer;
                transition: background 0.2s;
            }

            .landing-nav .theme-btn:hover {
                background: rgba(255, 255, 255, 0.1);
            }

            /* Main layout bounds */
            .hero-container {
                position: relative;
                z-index: 10;
                display: flex;
                flex-direction: column;
                align-items: center;
                padding: 60px 20px;
            }

            /* Glassmorphism Main Card */
            .landing-glass-card {
                background: rgba(255, 255, 255, 0.07);
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.15);
                border-radius: 24px;
                box-shadow: 0 25px 50px rgba(0, 0, 0, 0.4);
                padding: 60px 80px;
                max-width: 700px;
                width: 100%;
                text-align: center;
                animation: fadeInUp 0.8s ease forwards;
                box-sizing: border-box;
            }

            @media (max-width: 600px) {
                .landing-glass-card {
                    padding: 40px 30px;
                }

                .landing-heading {
                    font-size: 36px !important;
                }
            }

            /* Icon Glow */
            .icon-glow {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 0 40px rgba(102, 126, 234, 0.6);
                color: #e2e8f0;
                font-size: 60px;
                /* Base icon size to fit box */
                margin-bottom: 24px;
            }

            /* Typography */
            .landing-heading {
                font-size: 48px;
                font-weight: 700;
                color: white;
                background: linear-gradient(135deg, #ffffff, #a78bfa);
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
                text-shadow: 0 4px 20px rgba(167, 139, 250, 0.1);
                margin: 0 0 20px 0;
                letter-spacing: -0.5px;
            }

            .landing-subtitle {
                color: rgba(255, 255, 255, 0.7);
                font-size: 18px;
                line-height: 1.7;
                max-width: 550px;
                margin: 0 auto 40px;
            }

            /* Premium Arena Button */
            .btn-arena {
                background: linear-gradient(135deg, #667eea, #764ba2);
                padding: 18px 48px;
                font-size: 18px;
                font-weight: 600;
                border-radius: 50px;
                border: none;
                color: white;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                position: relative;
                overflow: hidden;
                transition: all 0.3s ease;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            }

            .btn-arena i {
                font-size: 16px;
            }

            .btn-arena::after {
                content: "";
                position: absolute;
                top: 0;
                left: -100%;
                width: 50%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
                animation: shimmer 3s infinite;
            }

            .btn-arena:hover {
                transform: translateY(-3px);
                box-shadow: 0 15px 35px rgba(102, 126, 234, 0.5);
                color: white;
            }

            .btn-arena:active {
                transform: translateY(-1px);
            }

            /* Actionable Feature Cards Row */
            .features-row {
                display: flex;
                gap: 20px;
                margin-top: 40px;
                justify-content: center;
                flex-wrap: wrap;
                width: 100%;
                max-width: 900px;
                position: relative;
                z-index: 10;
            }

            .feature-card {
                background: rgba(255, 255, 255, 0.05);
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 16px;
                padding: 20px 24px;
                flex: 1;
                min-width: 220px;
                text-align: center;
                opacity: 0;
                animation: fadeInUp 0.8s ease forwards;
                transition: all 0.3s ease;
                backdrop-filter: blur(10px);
                -webkit-backdrop-filter: blur(10px);
            }

            .feature-card:hover {
                background: rgba(255, 255, 255, 0.1);
                transform: translateY(-4px);
            }

            .feature-card i {
                font-size: 24px;
                background: linear-gradient(135deg, #667eea, #a78bfa);
                -webkit-background-clip: text;
                background-clip: text;
                -webkit-text-fill-color: transparent;
                margin-bottom: 12px;
                display: block;
            }

            .feature-card h3 {
                color: white;
                font-weight: 600;
                font-size: 16px;
                margin: 0 0 6px 0;
            }

            .feature-card p {
                color: rgba(255, 255, 255, 0.6);
                font-size: 13px;
                margin: 0;
                line-height: 1.4;
            }

            /* Stagger array */
            .fc-1 {
                animation-delay: 0.2s;
            }

            .fc-2 {
                animation-delay: 0.4s;
            }

            .fc-3 {
                animation-delay: 0.6s;
            }
        </style>
    </head>

    <body>
        <!-- Background Accents -->
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
        <div class="blob blob-3"></div>
        <div id="keyword-container"></div>

        <div class="landing-nav">
            <a href="index.jsp" style="text-decoration:none;">
                <h2><i class="fa-solid fa-graduation-cap"></i> QuizPro</h2>
            </a>
            <div class="landing-nav-links">
                <button onclick="cycleTheme()" id="theme-btn" class="theme-btn">🎨 Dark</button>
                <a href="login.jsp" class="btn"
                    style="padding: 8px 16px; border-radius: 5px; text-decoration:none;">Login</a>
                <a href="register.jsp" class="btn"
                    style="padding: 8px 16px; border-radius: 5px; background:rgba(255,255,255,0.1); text-decoration:none;">Register</a>
            </div>
        </div>

        <div class="hero-container">
            <div class="landing-glass-card">
                <div class="icon-glow">
                    <i class="fa-solid fa-laptop-code"></i>
                </div>

                <h1 class="landing-heading">Master Your Java Skills</h1>

                <p class="landing-subtitle">
                    Test your knowledge across multiple categories including Core Java, OOP Concepts, and Advanced
                    topics.
                </p>

                <a href="login.jsp" class="btn-arena"><i class="fa-solid fa-play"></i> Start Quiz Arena</a>
            </div>

            <div class="features-row">
                <div class="feature-card fc-1">
                    <i class="fa-solid fa-bolt"></i>
                    <h3>15 Questions</h3>
                    <p>Per category quiz</p>
                </div>
                <div class="feature-card fc-2">
                    <i class="fa-solid fa-layer-group"></i>
                    <h3>4 Categories</h3>
                    <p>Core, OOP, Advanced & Miscellaneous</p>
                </div>
                <div class="feature-card fc-3">
                    <i class="fa-solid fa-trophy"></i>
                    <h3>Instant Results</h3>
                    <p>Score + explanations & grade badges</p>
                </div>
            </div>
        </div>

        <script src="js/theme.js"></script>
        <script>
            // Float word simulation
            const container = document.getElementById('keyword-container');
            const keywords = ['class', 'void', 'static', 'public', 'return', 'import', 'extends', 'interface', 'new', 'throws', 'String', 'int', 'boolean'];

            const numWords = 10;

            for (let i = 0; i < numWords; i++) {
                let span = document.createElement('span');
                span.classList.add('floating-word');
                span.innerText = keywords[Math.floor(Math.random() * keywords.length)];

                // Random properties
                let left = Math.random() * 100; // 0 to 100vw
                let delay = Math.random() * 20; // up to 20s initial delay
                let duration = 15 + Math.random() * 15; // 15s to 30s
                let size = 14 + Math.floor(Math.random() * 9); // 14px to 22px

                span.style.left = left + 'vw';
                span.style.fontSize = size + 'px';
                span.style.animationDuration = duration + 's';
                span.style.animationDelay = delay + 's';
                span.style.bottom = '-50px'; // Start slightly offscreen below

                container.appendChild(span);
            }
        </script>
    </body>

    </html>