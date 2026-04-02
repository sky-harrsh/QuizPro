<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Question" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    @SuppressWarnings("unchecked")
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    if (questions == null || questions.isEmpty()) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    int totalQuestions = questions.size();
    String category = questions.get(0).getCategory();
    String categoryName = "Java Quiz";
    if("core".equals(category)) categoryName = "Core Java";
    else if("oop".equals(category)) categoryName = "OOP Concepts";
    else if("advanced".equals(category)) categoryName = "Advanced Java";
    else if("misc".equals(category)) categoryName = "Miscellaneous";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz - <%= categoryName %></title>
    <link rel="stylesheet" href="css/style.css">
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
    
    <div class="container">
        <div class="quiz-header">
            <h3><%= categoryName %></h3>
            <span id="questionCounter" style="font-weight: 600; color: var(--primary);">1 / <%= totalQuestions %></span>
        </div>
        
        <div class="progress-container">
            <div class="progress-bar" id="progressBar" <%= "style=\"width: " + (100.0/totalQuestions) + "%;\"" %>></div>
        </div>

        <form id="quizForm" action="ResultServlet" method="post">
            <% 
                int qNum = 1;
                for(Question q : questions) { 
            %>
            <div class="question-block <%= (qNum == 1) ? "active" : "" %>" id="qblock_<%= qNum %>">
                <h4 style="font-size: 20px; line-height: 1.5; margin-bottom: 30px;">
                    <span style="color: var(--primary);">Q<%= qNum %>.</span> <%= q.getQuestion() %>
                </h4>
                
                <div class="options-list">
                    <label class="option-label">
                        <input type="radio" name="q_<%= q.getId() %>" value="<%= q.getOption1() %>" required>
                        <span class="option-text"><%= q.getOption1() %></span>
                    </label>
                    <label class="option-label" style="margin-top: 15px;">
                        <input type="radio" name="q_<%= q.getId() %>" value="<%= q.getOption2() %>" required>
                        <span class="option-text"><%= q.getOption2() %></span>
                    </label>
                    <label class="option-label" style="margin-top: 15px;">
                        <input type="radio" name="q_<%= q.getId() %>" value="<%= q.getOption3() %>" required>
                        <span class="option-text"><%= q.getOption3() %></span>
                    </label>
                    <label class="option-label" style="margin-top: 15px;">
                        <input type="radio" name="q_<%= q.getId() %>" value="<%= q.getOption4() %>" required>
                        <span class="option-text"><%= q.getOption4() %></span>
                    </label>
                </div>
            </div>
            <% 
                qNum++;
                } 
            %>
            
            <div class="quiz-navigation">
                <button type="button" class="btn btn-outline" id="prevBtn" onclick="navigate(-1)" style="display: none;">
                    <i class="fa-solid fa-arrow-left"></i> Previous
                </button>
                <div style="flex-grow: 1;"></div>
                <button type="button" class="btn" id="nextBtn" onclick="navigate(1)">
                    Next <i class="fa-solid fa-arrow-right"></i>
                </button>
                <button type="submit" class="btn" id="submitBtn" style="display: none; background-color: var(--success);">
                    Submit Quiz <i class="fa-solid fa-check"></i>
                </button>
            </div>
        </form>
    </div>

    <input type="hidden" id="totQues" value="<%= totalQuestions %>">
    <script>
        let currentQuestion = 1;
        const totalQuestionsCount = parseInt(document.getElementById('totQues').value, 10);

        function navigate(step) {
            if(step === 1) {
                const currentBlock = document.getElementById('qblock_' + currentQuestion);
                const selected = currentBlock.querySelector('input[type="radio"]:checked');
                if(!selected) {
                    alert("Please select an answer before proceeding.");
                    return;
                }
            }

            document.getElementById('qblock_' + currentQuestion).classList.remove('active');
            currentQuestion += step;
            document.getElementById('qblock_' + currentQuestion).classList.add('active');
            
            document.getElementById('questionCounter').innerText = currentQuestion + ' / ' + totalQuestionsCount;
            document.getElementById('progressBar').style.width = ((currentQuestion / totalQuestionsCount) * 100) + '%';
            
            document.getElementById('prevBtn').style.display = (currentQuestion === 1) ? 'none' : 'inline-block';
            
            if (currentQuestion === totalQuestionsCount) {
                document.getElementById('nextBtn').style.display = 'none';
                document.getElementById('submitBtn').style.display = 'inline-block';
            } else {
                document.getElementById('nextBtn').style.display = 'inline-block';
                document.getElementById('submitBtn').style.display = 'none';
            }
        }
    </script>
</body>
</html>
