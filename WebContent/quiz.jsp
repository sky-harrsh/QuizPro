<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Question" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String category = (String) session.getAttribute("category");
    if (category == null) {
        response.sendRedirect("dashboard.jsp?msg=error");
        return;
    }
    
    // Debug (temporary)
    System.out.println("Quiz JSP Category: " + category);
    
    @SuppressWarnings("unchecked")
    List<Question> questions = (List<Question>) session.getAttribute("questions");
    if (questions == null || questions.isEmpty()) {
        response.sendRedirect("dashboard.jsp?msg=error");
        return;
    }
    int totalQuestions = questions.size();
    String categoryName = "Java Quiz";
    if("core".equals(category)) categoryName = "Core Java";
    else if("oop".equals(category)) categoryName = "OOP Concepts";
    else if("advanced".equals(category)) categoryName = "Advanced Java";
    else if("misc".equals(category)) categoryName = "Miscellaneous";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz - <%= categoryName %></title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- React & ReactDOM -->
    <script crossorigin src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>
    <!-- Babel -->
    <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>

    <style>
        body { background: #f0f2f5; font-family: 'Inter', sans-serif; }
        .grid-palette { display: grid; grid-template-columns: repeat(auto-fill, minmax(40px, 1fr)); gap: 10px; }
        .circle-btn {
            width: 40px; height: 40px; border-radius: 50%; display: flex;
            align-items: center; justify-content: center; font-weight: bold;
            cursor: pointer; transition: transform 0.1s, box-shadow 0.1s; border: 2px solid transparent;
        }
        .circle-btn:hover { transform: scale(1.1); box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .circle-btn.active { border: 2px solid #3b82f6; box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.5); }
        
        .status-not-visited { background-color: #e2e8f0; color: #475569; }
        .status-answered { background-color: #22c55e; color: white; }
        .status-skipped { background-color: #ef4444; color: white; }
        .status-review { background-color: #eab308; color: white; }
        
        .nav-header { background: #1e293b; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        
        /* Custom Code Block Theme */
        pre.code-block { background-color: #1e1e1e; color: #d4d4d4; padding: 16px; border-radius: 8px; overflow-x: auto; font-family: 'Consolas', 'Monaco', monospace; font-size: 14px; line-height: 1.5; margin: 16px 0; border: 1px solid #333; }
        .input-inline { display: inline-block; width: 120px; margin: 0 8px; padding: 4px 8px; border-bottom: 2px solid #3b82f6; border-top: none; border-left: none; border-right: none; background: transparent; color: inherit; font-family: inherit; font-size: inherit; text-align: center; transition: border-color 0.2s; outline: none; }
        .input-inline:focus { border-bottom-color: #22c55e; }
        /* In case of light text/code */
        .input-inline-light { color: #d4d4d4; border-bottom: 2px solid #60a5fa; }
    </style>
</head>
<body>
    <div class="nav-header">
        <a href="dashboard.jsp" title="Go to Dashboard" style="text-decoration: none; color: white;">
            <h2 style="margin:0; font-size: 24px; color: #ffffff;"><i class="fa-solid fa-graduation-cap" style="color: #ffffff;"></i> QuizPro</h2>
        </a>
        <div style="display: flex; align-items: center; gap: 15px;">
            <button onclick="cycleTheme()" id="theme-btn" class="btn" style="background:transparent; border:1px solid; padding: 5px 15px; border-radius: 5px; font-weight: bold; color: #ffffff; border-color: rgba(255,255,255,0.3);">🎨 Dark</button>
            <a href="LogoutServlet" style="color: #ff6b6b; text-decoration: none;"><i class="fa-solid fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <!-- Injecting Questions from JSP avoiding <script> to quiet IDE JS linters -->
    <div id="quiz-data-container" style="display:none;">
        [
        <% 
            int i = 0;
            for(Question q: questions) {
                if(i > 0) out.print(",");
                i++;
                String cleanQuestion = q.getQuestion().replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
                String opt1 = q.getOption1().replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
                String opt2 = q.getOption2().replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
                String opt3 = q.getOption3().replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
                String opt4 = q.getOption4().replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
        %>
        {
            "id": <%= q.getId() %>,
            "question": "<%= cleanQuestion %>",
            "options": [ "<%= opt1 %>", "<%= opt2 %>", "<%= opt3 %>", "<%= opt4 %>" ]
        }
        <% } %>
        ]
    </div>

    <script>
        const rawJsonStr = document.getElementById('quiz-data-container').textContent.trim();
        const quizQuestions = JSON.parse(rawJsonStr);
        window.quizCategoryName = "<%= categoryName %>";
    </script>

    <div id="root"></div>

    <script type="text/babel">
        // --- Components ---

        const CodeBlock = ({ content, answer, onAnswerChange, isFillInBlank }) => {
            // Remove <pre> tags if already wrapped from backend AI string
            let code = content.replace(/<\/?pre>/g, '').replace(/<\/?code>/g, '').trim();
            
            // If Fill-in-the-blanks, parse the "___"
            if (isFillInBlank) {
                const parts = code.split('___');
                return (
                    <pre className="code-block text-left">
                        {parts.map((part, idx) => (
                            <React.Fragment key={idx}>
                                {part}
                                {idx < parts.length - 1 && (
                                    <input 
                                        type="text"
                                        className="input-inline input-inline-light"
                                        value={answer || ''}
                                        onChange={(e) => onAnswerChange(e.target.value)}
                                        placeholder="type here"
                                        autoComplete="off"
                                    />
                                )}
                            </React.Fragment>
                        ))}
                    </pre>
                );
            }
            // Normal code snippet display
            return <pre className="code-block text-left">{code}</pre>;
        };

        const InputHandler = ({ questionId, options, isFillInBlank, answer, onAnswerChange }) => {
            if (isFillInBlank) {
                // If there's NO code block, we render a standalone text input (fallback)
                return (
                    <div className="mt-6">
                        <input 
                            type="text" 
                            className="w-full text-lg p-4 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                            placeholder="Type your exact answer here..."
                            value={answer || ''}
                            onChange={(e) => onAnswerChange(e.target.value)}
                            autoComplete="off"
                        />
                    </div>
                );
            }

            // Regular MCQ Radio Options
            return (
                <div className="space-y-4 mt-6">
                    {options.map((opt, idx) => (
                        <label key={idx} className={`block p-4 border rounded-lg cursor-pointer transition-all ${answer === opt ? 'border-blue-500 bg-blue-50 shadow-sm' : 'border-slate-200 bg-white hover:bg-slate-50'}`}>
                            <div className="flex items-center">
                                <input 
                                    type="radio" 
                                    name={`q_rb_${questionId}`} 
                                    value={opt}
                                    checked={answer === opt}
                                    onChange={() => onAnswerChange(opt)}
                                    className="w-5 h-5 text-blue-600 border-gray-300 focus:ring-blue-500"
                                />
                                <span className="ml-3 text-slate-700 text-lg">{opt}</span>
                            </div>
                        </label>
                    ))}
                </div>
            );
        };

        const QuestionCard = ({ 
            currentQ, 
            currentIndex, 
            totalQuestions, 
            answer, 
            onAnswerChange, 
            onNext, 
            onPrev, 
            onSkip, 
            onReview 
        }) => {
            
            // Heuristics to detect format
            const isAdvanced = window.quizCategoryName === "Advanced Java";
            const qStr = currentQ.question;
            const hasBlanks = qStr.includes('___');
            // If the category is advanced AND it looks like code, or explicitly has <pre>
            const hasCodeSnippets = qStr.includes('<pre>') || qStr.includes('public class') || qStr.includes('public static');

            // Extraction logic for advanced formatting
            let normalText = qStr;
            let codeSnippet = "";

            if (hasCodeSnippets) {
                // Try to extract <pre>
                if (qStr.includes('<pre>')) {
                    const parts = qStr.split('<pre>');
                    normalText = parts[0];
                    codeSnippet = '<pre>' + parts[1]; // keep <pre> block for parsing in CodeBlock
                } else {
                    // Fallback: If it's pure code text without tags but identifiable
                    // Assuming everything is code if it starts with code-like tokens
                    normalText = "Analyze the code below:";
                    codeSnippet = qStr;
                }
            }

            return (
                <div className="w-full lg:w-8/12 bg-white rounded-xl shadow-md flex flex-col overflow-hidden border border-slate-200">
                    <div className="bg-slate-50 border-b border-slate-200 px-6 py-4 flex justify-between items-center">
                        <h2 className="text-xl font-bold text-slate-800">{window.quizCategoryName}</h2>
                        <span className="text-blue-600 font-semibold">Question {currentIndex + 1} of {totalQuestions}</span>
                    </div>
                    
                    <div className="p-8 flex-1 overflow-y-auto">
                        {/* Progress Bar Micro */}
                        <div className="w-full bg-slate-200 h-1.5 rounded-full mb-6">
                            <div className="bg-blue-600 h-1.5 rounded-full transition-all" style={{ width: `${((currentIndex + 1) / totalQuestions) * 100}%` }}></div>
                        </div>

                        <h3 className="text-xl text-slate-800 mb-4 leading-relaxed font-medium" 
                            dangerouslySetInnerHTML={{__html: `Q${currentIndex + 1}. ` + normalText}}>
                        </h3>
                        
                        {/* Advanced Java Code Snippet Injection */}
                        {hasCodeSnippets && (
                            <CodeBlock 
                                content={codeSnippet} 
                                isFillInBlank={hasBlanks} 
                                answer={answer} 
                                onAnswerChange={onAnswerChange} 
                            />
                        )}
                        
                        {/* If it's a fill in the blank inside a code snippet, we omit the standard input/MCQ handler, since CodeBlock handles it. 
                            Otherwise, we render InputHandler. */}
                        {(!hasCodeSnippets || !hasBlanks) && (
                            <InputHandler 
                                questionId={currentQ.id}
                                options={currentQ.options} 
                                isFillInBlank={hasBlanks && !hasCodeSnippets} 
                                answer={answer} 
                                onAnswerChange={onAnswerChange} 
                            />
                        )}
                    </div>
                    
                    <div className="bg-slate-50 border-t border-slate-200 p-4 flex flex-wrap gap-4 items-center justify-between">
                        <div className="flex gap-3">
                            <button onClick={onPrev} disabled={currentIndex === 0} className="px-5 py-2.5 bg-slate-200 text-slate-700 rounded-lg hover:bg-slate-300 disabled:opacity-50 font-medium transition-colors">
                                <i className="fa-solid fa-arrow-left mr-2"></i> Previous
                            </button>
                            <button onClick={onNext} disabled={currentIndex === totalQuestions - 1} className="px-5 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 font-medium transition-colors">
                                Next <i className="fa-solid fa-arrow-right ml-2"></i>
                            </button>
                        </div>
                        <div className="flex gap-3">
                            <button onClick={onReview} className="px-5 py-2.5 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600 font-medium transition-colors shadow">
                                <i className="fa-solid fa-bookmark mr-2"></i> Mark for Review
                            </button>
                            <button onClick={onSkip} className="px-5 py-2.5 bg-red-500 text-white rounded-lg hover:bg-red-600 font-medium transition-colors shadow">
                                <i className="fa-solid fa-forward-step mr-2"></i> Skip
                            </button>
                        </div>
                    </div>
                </div>
            );
        };

        const QuestionPalette = ({ 
            questions, 
            currentIndex, 
            statuses, 
            onSelect, 
            stats, 
            answers 
        }) => {
            return (
                <div className="w-full lg:w-4/12 bg-white rounded-xl shadow-md flex flex-col overflow-hidden border border-slate-200">
                    <div className="bg-slate-50 border-b border-slate-200 px-6 py-4 flex justify-between items-center">
                        <h2 className="text-lg font-bold text-slate-800">Question Palette</h2>
                    </div>
                    
                    {/* Legend */}
                    <div className="p-4 border-b border-slate-200 bg-slate-50 text-sm">
                        <div className="grid grid-cols-2 gap-3 mb-2">
                            <div className="flex items-center gap-2"><div className="w-4 h-4 rounded-full status-answered"></div> Answered: <span className="font-bold">{stats.answered}</span></div>
                            <div className="flex items-center gap-2"><div className="w-4 h-4 rounded-full status-skipped"></div> Skipped: <span className="font-bold">{stats.skipped}</span></div>
                        </div>
                        <div className="grid grid-cols-2 gap-3">
                            <div className="flex items-center gap-2"><div className="w-4 h-4 rounded-full status-review"></div> Review: <span className="font-bold">{stats.review}</span></div>
                            <div className="flex items-center gap-2"><div className="w-4 h-4 rounded-full status-not-visited border border-slate-300"></div> Not Visited: <span className="font-bold">{stats.notVisited}</span></div>
                        </div>
                    </div>

                    {/* Palette Grid */}
                    <div className="p-6 flex-1 overflow-y-auto">
                        <div className="grid-palette">
                            {questions.map((q, idx) => (
                                <div 
                                    key={idx} 
                                    onClick={() => onSelect(idx)}
                                    className={`circle-btn status-${statuses[q.id]} ${currentIndex === idx ? 'active' : ''}`}
                                    title={`Question ${idx + 1}`}
                                >
                                    {idx + 1}
                                </div>
                            ))}
                        </div>
                    </div>

                    {/* Form Submission Payload */}
                    <div className="p-4 border-t border-slate-200 bg-slate-50">
                        <form action="ResultServlet" method="post" className="w-full">
                            {questions.map((q, idx) => (
                                <input key={q.id} type="hidden" name={`answer_${idx}`} value={answers[q.id] || ""} />
                            ))}
                            <button type="submit" className="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-4 rounded-xl shadow transition-colors flex items-center justify-center text-lg uppercase tracking-wide">
                                <i className="fa-solid fa-check-double mr-2"></i> Submit Final Quiz
                            </button>
                        </form>
                    </div>
                </div>
            );
        };

        const Timer = () => {
            const [timeLeft, setTimeLeft] = React.useState(16 * 60); // 16 minutes default
            
            React.useEffect(() => {
                const interval = setInterval(() => {
                    setTimeLeft(prev => prev > 0 ? prev - 1 : 0);
                }, 1000);
                return () => clearInterval(interval);
            }, []);

            const mins = Math.floor(timeLeft / 60).toString().padStart(2, '0');
            const secs = (timeLeft % 60).toString().padStart(2, '0');
            
            return (
                <div className="flex items-center gap-2 bg-slate-800 text-white px-4 py-2 rounded-lg font-mono text-lg font-bold shadow-inner">
                    <i className={`fa-regular fa-clock ${timeLeft < 300 ? 'text-red-400 animate-pulse' : 'text-blue-300'}`}></i>
                    <span className={timeLeft < 300 ? 'text-red-400' : ''}>{mins}:{secs}</span>
                </div>
            );
        };

        function QuizApp() {
            const [currentIndex, setCurrentIndex] = React.useState(0);
            const [answers, setAnswers] = React.useState({});
            const [statuses, setStatuses] = React.useState(() => {
                const init = {};
                quizQuestions.forEach(q => init[q.id] = "not-visited");
                return init;
            });

            const currentQ = quizQuestions[currentIndex];

            const handleAnswerChange = (val) => {
                setAnswers(prev => ({ ...prev, [currentQ.id]: val }));
                setStatuses(prev => ({ ...prev, [currentQ.id]: "answered" }));
            };

            const markSkipped = () => {
                if(statuses[currentQ.id] !== "answered") {
                    setStatuses(prev => ({ ...prev, [currentQ.id]: "skipped" }));
                }
                goToNext();
            };

            const markReview = () => {
                setStatuses(prev => ({ ...prev, [currentQ.id]: "review" }));
                goToNext();
            };

            const goToNext = () => {
                if (currentIndex < quizQuestions.length - 1) {
                    setCurrentIndex(currentIndex + 1);
                }
            };

            const goToPrev = () => {
                if (currentIndex > 0) {
                    setCurrentIndex(currentIndex - 1);
                }
            };

            let stats = { answered: 0, skipped: 0, review: 0, notVisited: 0 };
            Object.values(statuses).forEach(v => {
                if(v === "answered") stats.answered++;
                else if(v === "skipped") stats.skipped++;
                else if(v === "review") stats.review++;
                else stats.notVisited++;
            });

            return (
                <div className="flex flex-col gap-6">
                    <div className="flex justify-between items-center bg-white px-6 py-3 rounded-xl shadow-sm border border-slate-200 mx-4 mt-4 max-w-7xl lg:mx-auto w-full box-border">
                        <div className="font-semibold text-slate-700 flex items-center gap-2">
                            <i className="fa-solid fa-laptop-code text-blue-600"></i>
                            Live Exam Instance
                        </div>
                        <Timer />
                    </div>
                
                    <div className="flex flex-col lg:flex-row max-w-7xl mx-auto px-4 pb-8 gap-6 w-full h-[calc(100vh-160px)]">
                        <QuestionCard 
                            currentQ={currentQ}
                            currentIndex={currentIndex}
                            totalQuestions={quizQuestions.length}
                            answer={answers[currentQ.id]}
                            onAnswerChange={handleAnswerChange}
                            onNext={goToNext}
                            onPrev={goToPrev}
                            onSkip={markSkipped}
                            onReview={markReview}
                        />
                        <QuestionPalette 
                            questions={quizQuestions}
                            currentIndex={currentIndex}
                            statuses={statuses}
                            onSelect={setCurrentIndex}
                            stats={stats}
                            answers={answers}
                        />
                    </div>
                </div>
            );
        }

        const root = ReactDOM.createRoot(document.getElementById('root'));
        root.render(<QuizApp />);
    </script>
</body>
</html>
