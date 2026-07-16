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
    System.out.println("Quiz JSP Category: " + category);

    @SuppressWarnings("unchecked") List<Question> questions = (List<Question>) session.getAttribute("questions");
    if (questions == null || questions.isEmpty()) {
        response.sendRedirect("dashboard.jsp?msg=error");
        return;
    }
    int totalQuestions = questions.size();
    String categoryName = "Java Quiz";
    if ("core".equals(category)) categoryName = "Core Java";
    else if ("oop".equals(category)) categoryName = "OOP Concepts";
    else if ("advanced".equals(category)) categoryName = "Advanced Java";
    else if ("misc".equals(category)) categoryName = "Miscellaneous";
%>
<!DOCTYPE html>
<html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Quiz - <%= categoryName %>
                        </title>
                        <!-- Tailwind CSS -->
                        <script src="https://cdn.tailwindcss.com"></script>
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                        <!-- Dependencies: React & ReactDOM (Standard JS) -->
    <script crossorigin src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>

                        <style>
                            body {
                                background: #f0f2f5;
                                font-family: 'Inter', sans-serif;
                            }

                            .grid-palette {
                                display: grid;
                                grid-template-columns: repeat(auto-fill, minmax(40px, 1fr));
                                gap: 10px;
                            }

                            .circle-btn {
                                width: 40px;
                                height: 40px;
                                border-radius: 50%;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-weight: bold;
                                cursor: pointer;
                                transition: transform 0.1s, box-shadow 0.1s;
                                border: 2px solid transparent;
                            }

                            .circle-btn:hover {
                                transform: scale(1.1);
                                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                            }

                            .circle-btn.active {
                                border: 2px solid #3b82f6;
                                box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.5);
                            }

                            .status-not-visited {
                                background-color: #e2e8f0;
                                color: #475569;
                            }

                            .status-answered {
                                background-color: #22c55e;
                                color: white;
                            }

                            .status-skipped {
                                background-color: #ef4444;
                                color: white;
                            }

                            .status-review {
                                background-color: #eab308;
                                color: white;
                            }

                            .nav-header {
                                background: #1e293b;
                                color: white;
                                padding: 15px 30px;
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                            }

                            /* Custom Code Block Theme */
                            pre.code-block {
                                background-color: #1e1e1e;
                                color: #d4d4d4;
                                padding: 16px;
                                border-radius: 8px;
                                overflow-x: auto;
                                font-family: 'Consolas', 'Monaco', monospace;
                                font-size: 14px;
                                line-height: 1.5;
                                margin: 16px 0;
                                border: 1px solid #333;
                            }

                            .input-inline {
                                display: inline-block;
                                width: 120px;
                                margin: 0 8px;
                                padding: 4px 8px;
                                border-bottom: 2px solid #3b82f6;
                                border-top: none;
                                border-left: none;
                                border-right: none;
                                background: transparent;
                                color: inherit;
                                font-family: inherit;
                                font-size: inherit;
                                text-align: center;
                                transition: border-color 0.2s;
                                outline: none;
                            }

                            .input-inline:focus {
                                border-bottom-color: #22c55e;
                            }

                            /* In case of light text/code */
                            .input-inline-light {
                                color: #d4d4d4;
                                border-bottom: 2px solid #60a5fa;
                            }
                        </style>
                    </head>

                    <body>
                        <div class="nav-header">
                            <a href="dashboard.jsp" title="Go to Dashboard"
                                style="text-decoration: none; color: white;">
                                <h2 style="margin:0; font-size: 24px; color: #ffffff;"><i
                                        class="fa-solid fa-graduation-cap" style="color: #ffffff;"></i> QuizPro</h2>
                            </a>
                            <div style="display: flex; align-items: center; gap: 15px;">
                                <button onclick="cycleTheme()" id="theme-btn" class="btn"
                                    style="background:transparent; border:1px solid; padding: 5px 15px; border-radius: 5px; font-weight: bold; color: #ffffff; border-color: rgba(255,255,255,0.3);">🎨
                                    Dark</button>
                                <a href="LogoutServlet" style="color: #ff6b6b; text-decoration: none;"><i
                                        class="fa-solid fa-sign-out-alt"></i> Logout</a>
                            </div>
                        </div>

                        <%-- Helper to escape strings for JavaScript --%>
                            <%! public String escapeJS(String input) { if (input==null) return "" ; return
                                input.replace("\\", "\\\\" ) .replace("\"", "\\\"")
                        .replace("'", "\\'")
                        .replace(" \r", "" ) .replace("\n", "\\n" ) .replace("\t", "\\t" ); } %>

                                   <%
        StringBuilder sb = new StringBuilder("[");
        for(int j = 0; j < questions.size(); j++) {
            Question q = questions.get(j);
            if(j > 0) sb.append(",");
            sb.append("{")
              .append("\"id\":").append(q.getId()).append(",")
              .append("\"question\":\"").append(escapeJS(q.getQuestion())).append("\",")
              .append("\"options\":[")
              .append("\"").append(escapeJS(q.getOption1())).append("\",")
              .append("\"").append(escapeJS(q.getOption2())).append("\",")
              .append("\"").append(escapeJS(q.getOption3())).append("\",")
              .append("\"").append(escapeJS(q.getOption4())).append("\"")
              .append("]")
              .append("}");
        }
        sb.append("]");
        String finalJson = sb.toString();
    %>
    <!-- Hidden textarea is much safer for large/complex JSON than a data attribute -->
    <textarea id="quiz-data-json" style="display:none;"><%= finalJson %></textarea>

    <div id="loading-overlay" style="position:fixed; top:70px; left:0; width:100%; height:calc(100% - 70px); background:#f0f2f5; display:flex; flex-direction:column; justify-content:center; align-items:center; z-index:100;">
        <div style="width:50px; height:50px; border:5px solid #cbd5e1; border-top-color:#3b82f6; border-radius:50%; animation:spin 1s linear infinite;"></div>
        <p style="margin-top:20px; color:#64748b; font-weight:600; font-family:sans-serif;">Preparing your questions...</p>
        <style>@keyframes spin { to { transform: rotate(360deg); } }</style>
    </div>

    <script>
        // Check if dependencies loaded
        window.addEventListener('load', () => {
            setTimeout(() => {
                const loader = document.getElementById('loading-overlay');
                if (loader && !window.reactMounted) {
                    loader.innerHTML = '<div style="color:#ef4444; padding:20px; background:white; border-radius:12px; shadow:md; text-align:center; max-width:80%;">' +
                        '<h2 style="margin-bottom:10px;">Initialization Timeout</h2>' +
                        '<p>The quiz app is taking too long to start. This might be due to a script loading error or an issue with the quiz data.</p>' +
                        '<button onclick="location.reload()" style="margin-top:15px; padding:8px 20px; background:#3b82f6; color:white; border:none; border-radius:6px; cursor:pointer;">Retry</button>' +
                        '</div>';
                }
            }, 5000);

            if (typeof React === 'undefined' || typeof ReactDOM === 'undefined') {
                console.error("React failed to load!");
                document.getElementById('root').innerHTML = '<div style="color:red; padding:20px; background:white; margin:20px; border-radius:8px; border:1px solid red;">' +
                    '<strong>Error:</strong> React/ReactDOM failed to load from unpkg.com. Please check your internet connection.</div>';
            }
        });

        try {
            const jsonElement = document.getElementById('quiz-data-json');
            const rawJsonStr = jsonElement ? jsonElement.value : "[]";
            console.log("Found JSON in textarea, length:", rawJsonStr.length);
            
            const quizQuestions = JSON.parse(rawJsonStr);
            window.quizQuestions = quizQuestions;
            window.quizCategoryName = "<%= categoryName %>";
            console.log("Quiz Data Parsed Successfully");
        } catch (e) {
            console.error("Critical JSON/Initialization Error:", e);
            const root = document.getElementById('root');
            if (root) {
                root.innerHTML = `<div style="padding:40px; color:#c0392b; background:#fdf2f2; font-family:sans-serif; text-align:center; margin:20px; border-radius:12px; border:1px solid #fca5a5;">
                    <h1 style="font-size:24px; margin-bottom:16px;">Quiz Generation Error</h1>
                    <p style="font-size:16px; margin-bottom:20px;">The data for this quiz category contains invalid characters or a formatting error.</p>
                    <pre style="background:#fff; border:1px solid #e1e4e8; padding:15px; border-radius:8px; text-align:left; max-width:90%; margin:0 auto; overflow-x:auto;">${e.message}</pre>
                    <div style="margin-top:30px;"><a href="dashboard.jsp" style="text-decoration:none; background:#2563eb; color:white; padding:12px 24px; border-radius:6px; font-weight:600;">Return to Dashboard</a></div>
                </div>`;
                const overlay = document.getElementById('loading-overlay');
                if (overlay) overlay.style.display = 'none';
            }
        }
    </script>

                                    <div id="root"></div>    <script>
        // --- React Standard JavaScript Implementation (No Babel Needed) ---
        const h = React.createElement;
        const F = React.Fragment;

        // --- Error Boundary ---
        class ErrorBoundary extends React.Component {
            constructor(props) {
                super(props);
                this.state = { hasError: false, error: null };
            }
            static getDerivedStateFromError(error) { return { hasError: true, error }; }
            render() {
                if (this.state.hasError) {
                    return h('div', { className: "p-8 text-center bg-white rounded-xl shadow mt-10 mx-auto max-w-2xl" },
                        h('h1', { className: "text-2xl font-bold text-red-600 mb-4" }, "Quiz Rendering Error"),
                        h('p', { className: "text-slate-600 mb-4" }, this.state.error?.message || "Unknown error"),
                        h('button', { onClick: () => window.location.reload(), className: "px-6 py-2 bg-blue-600 text-white rounded-lg" }, "Retry")
                    );
                }
                return this.props.children;
            }
        }

        console.log("Quiz Logic Initializing...");
        const quizQuestions = window.quizQuestions || [];
        
        // --- Components ---

        const CodeBlock = ({ content, answer, onAnswerChange, isFillInBlank }) => {
            let code = content.replace(/<\/?pre>/g, '').replace(/<\/?code>/g, '').trim();

            if (isFillInBlank) {
                const parts = code.split('___');
                return h('pre', { className: "code-block text-left" },
                    parts.map((part, idx) => h(F, { key: idx },
                        part,
                        idx < parts.length - 1 && h('input', {
                            type: "text",
                            className: "input-inline input-inline-light",
                            value: answer || '',
                            onChange: (e) => onAnswerChange(e.target.value),
                            placeholder: "type here",
                            autoComplete: "off"
                        })
                    ))
                );
            }
            return h('pre', { className: "code-block text-left" }, code);
        };

        const InputHandler = ({ questionId, options, isFillInBlank, answer, onAnswerChange }) => {
            if (isFillInBlank) {
                return h('div', { className: "mt-6" },
                    h('input', {
                        type: "text",
                        className: "w-full text-lg p-4 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none",
                        placeholder: "Type your exact answer here...",
                        value: answer || '',
                        onChange: (e) => onAnswerChange(e.target.value),
                        autoComplete: "off"
                    })
                );
            }

            return h('div', { className: "space-y-4 mt-6" },
                options.map((opt, idx) => h('label', {
                    key: idx,
                    className: `block p-4 border rounded-lg cursor-pointer transition-all ${answer === opt ? 'border-blue-500 bg-blue-50 shadow-sm' : 'border-slate-200 bg-white hover:bg-slate-50'}`
                }, h('div', { className: "flex items-center" },
                    h('input', {
                        type: "radio",
                        name: `q_rb_${questionId}`,
                        value: opt,
                        checked: answer === opt,
                        onChange: () => onAnswerChange(opt),
                        className: "w-5 h-5 text-blue-600 border-gray-300 focus:ring-blue-500"
                    }),
                    h('span', { className: "ml-3 text-slate-700 text-lg" }, opt)
                )))
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
            const qStr = currentQ.question;
            const hasBlanks = qStr.includes('___');
            const hasCodeSnippets = qStr.includes('<pre>') || qStr.includes('public class') || qStr.includes('public static');

            let normalText = qStr;
            let codeSnippet = "";

            if (hasCodeSnippets) {
                if (qStr.includes('<pre>')) {
                    const parts = qStr.split('<pre>');
                    normalText = parts[0];
                    codeSnippet = '<pre>' + parts[1];
                } else {
                    normalText = "Analyze the code below:";
                    codeSnippet = qStr;
                }
            }

            return h('div', { className: "w-full lg:w-8/12 bg-white rounded-xl shadow-md flex flex-col overflow-hidden border border-slate-200" },
                h('div', { className: "bg-slate-50 border-b border-slate-200 px-6 py-4 flex justify-between items-center" },
                    h('h2', { className: "text-xl font-bold text-slate-800" }, window.quizCategoryName),
                    h('span', { className: "text-blue-600 font-semibold" }, `Question ${currentIndex + 1} of ${totalQuestions}`)
                ),
                h('div', { className: "p-8 flex-1 overflow-y-auto" },
                    h('div', { className: "w-full bg-slate-200 h-1.5 rounded-full mb-6" },
                        h('div', { className: "bg-blue-600 h-1.5 rounded-full transition-all", style: { width: `${((currentIndex + 1) / totalQuestions) * 100}%` } })
                    ),
                    h('h3', {
                        className: "text-xl text-slate-800 mb-4 leading-relaxed font-medium",
                        dangerouslySetInnerHTML: { __html: `Q${currentIndex + 1}. ` + normalText }
                    }),
                    hasCodeSnippets && h(CodeBlock, { content: codeSnippet, isFillInBlank: hasBlanks, answer, onAnswerChange }),
                    (!hasCodeSnippets || !hasBlanks) && h(InputHandler, {
                        questionId: currentQ.id,
                        options: currentQ.options,
                        isFillInBlank: hasBlanks && !hasCodeSnippets,
                        answer,
                        onAnswerChange
                    })
                ),
                h('div', { className: "bg-slate-50 border-t border-slate-200 p-4 flex flex-wrap gap-4 items-center justify-between" },
                    h('div', { className: "flex gap-3" },
                        h('button', { onClick: onPrev, disabled: currentIndex === 0, className: "px-5 py-2.5 bg-slate-200 text-slate-700 rounded-lg hover:bg-slate-300 disabled:opacity-50 font-medium transition-colors" },
                            h('i', { className: "fa-solid fa-arrow-left mr-2" }), " Previous"
                        ),
                        h('button', { onClick: onNext, disabled: currentIndex === totalQuestions - 1, className: "px-5 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 font-medium transition-colors" },
                            "Next ", h('i', { className: "fa-solid fa-arrow-right ml-2" })
                        )
                    ),
                    h('div', { className: "flex gap-3" },
                        h('button', { onClick: onReview, className: "px-5 py-2.5 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600 font-medium transition-colors shadow" },
                            h('i', { className: "fa-solid fa-bookmark mr-2" }), " Mark for Review"
                        ),
                        h('button', { onClick: onSkip, className: "px-5 py-2.5 bg-red-500 text-white rounded-lg hover:bg-red-600 font-medium transition-colors shadow" },
                            h('i', { className: "fa-solid fa-forward-step mr-2" }), " Skip"
                        )
                    )
                )
            );
        };

        const QuestionPalette = ({ questions, currentIndex, statuses, onSelect, stats, answers }) => {
            return h('div', { className: "w-full lg:w-4/12 bg-white rounded-xl shadow-md flex flex-col overflow-hidden border border-slate-200" },
                h('div', { className: "bg-slate-50 border-b border-slate-200 px-6 py-4 flex justify-between items-center" },
                    h('h2', { className: "text-lg font-bold text-slate-800" }, "Question Palette")
                ),
                h('div', { className: "p-4 border-b border-slate-200 bg-slate-50 text-sm" },
                    h('div', { className: "grid grid-cols-2 gap-3 mb-2" },
                        h('div', { className: "flex items-center gap-2" }, h('div', { className: "w-4 h-4 rounded-full status-answered" }), " Answered: ", h('span', { className: "font-bold" }, stats.answered)),
                        h('div', { className: "flex items-center gap-2" }, h('div', { className: "w-4 h-4 rounded-full status-skipped" }), " Skipped: ", h('span', { className: "font-bold" }, stats.skipped))
                    ),
                    h('div', { className: "grid grid-cols-2 gap-3" },
                        h('div', { className: "flex items-center gap-2" }, h('div', { className: "w-4 h-4 rounded-full status-review" }), " Review: ", h('span', { className: "font-bold" }, stats.review)),
                        h('div', { className: "flex items-center gap-2" }, h('div', { className: "w-4 h-4 rounded-full status-not-visited border border-slate-300" }), " Not Visited: ", h('span', { className: "font-bold" }, stats.notVisited))
                    )
                ),
                h('div', { className: "p-6 flex-1 overflow-y-auto" },
                    h('div', { className: "grid-palette" },
                        questions.map((q, idx) => h('div', {
                            key: idx,
                            onClick: () => onSelect(idx),
                            className: `circle-btn status-${statuses[q.id]} ${currentIndex === idx ? 'active' : ''}`,
                            title: `Question ${idx + 1}`
                        }, idx + 1))
                    )
                ),
                h('div', { className: "p-4 border-t border-slate-200 bg-slate-50" },
                    h('form', { action: "ResultServlet", method: "post", className: "w-full" },
                        questions.map((q, idx) => h('input', { key: q.id, type: "hidden", name: `answer_${idx}`, value: answers[q.id] || "" })),
                        h('button', { type: "submit", className: "w-full bg-green-600 hover:bg-green-700 text-white font-bold py-4 rounded-xl shadow transition-colors flex items-center justify-center text-lg uppercase tracking-wide" },
                            h('i', { className: "fa-solid fa-check-double mr-2" }), " Submit Final Quiz"
                        )
                    )
                )
            );
        };

        const Timer = () => {
            const [timeLeft, setTimeLeft] = React.useState(16 * 60);
            React.useEffect(() => {
                const interval = setInterval(() => setTimeLeft(prev => prev > 0 ? prev - 1 : 0), 1000);
                return () => clearInterval(interval);
            }, []);
            const mins = Math.floor(timeLeft / 60).toString().padStart(2, '0');
            const secs = (timeLeft % 60).toString().padStart(2, '0');
            return h('div', { className: "flex items-center gap-2 bg-slate-800 text-white px-4 py-2 rounded-lg font-mono text-lg font-bold shadow-inner" },
                h('i', { className: `fa-regular fa-clock ${timeLeft < 300 ? 'text-red-400 animate-pulse' : 'text-blue-300'}` }),
                h('span', { className: timeLeft < 300 ? 'text-red-400' : '' }, `${mins}:${secs}`)
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

            React.useEffect(() => {
                window.reactMounted = true;
                const overlay = document.getElementById('loading-overlay');
                if (overlay) overlay.style.display = 'none';
                console.log("Quiz App Mounted Successfully");
            }, []);

            if (!quizQuestions || quizQuestions.length === 0) {
                return h('div', { className: "p-8 text-center bg-white rounded-xl shadow mt-10 mx-auto max-w-2xl" },
                    h('h1', { className: "text-2xl font-bold text-slate-800 mb-4" }, "No Questions Found"),
                    h('p', { className: "text-slate-600 mb-4" }, "We couldn't load any questions for this category."),
                    h('a', { href: "dashboard.jsp", className: "px-6 py-2 bg-blue-600 text-white rounded-lg" }, "Return to Dashboard")
                );
            }

            const currentQ = quizQuestions[currentIndex];
            const totalQuestions = quizQuestions.length;

            const handleAnswerChange = (val) => {
                setAnswers(prev => ({ ...prev, [currentQ.id]: val }));
                setStatuses(prev => ({ ...prev, [currentQ.id]: "answered" }));
            };

            const markSkipped = () => {
                if (statuses[currentQ.id] !== "answered") setStatuses(prev => ({ ...prev, [currentQ.id]: "skipped" }));
                goToNext();
            };

            const markReview = () => {
                setStatuses(prev => ({ ...prev, [currentQ.id]: "review" }));
                goToNext();
            };

            const goToNext = () => { if (currentIndex < totalQuestions - 1) setCurrentIndex(prev => prev + 1); };
            const goToPrev = () => { if (currentIndex > 0) setCurrentIndex(prev => prev - 1); };

            const stats = {
                answered: Object.values(statuses).filter(s => s === "answered").length,
                skipped: Object.values(statuses).filter(s => s === "skipped").length,
                review: Object.values(statuses).filter(s => s === "review").length,
                notVisited: Object.values(statuses).filter(s => s === "not-visited").length
            };

            return h('div', { className: "container mx-auto px-4 py-8 max-w-7xl" },
                h('div', { className: "flex justify-between items-center mb-8 bg-white p-4 rounded-xl shadow-sm border border-slate-200" },
                    h('div', null,
                        h('h1', { className: "text-2xl font-bold text-slate-800" }, "Quiz Arena"),
                        h('p', { className: "text-slate-500" }, `Category: ${window.quizCategoryName}`)
                    ),
                    h(Timer)
                ),
                h('div', { className: "flex flex-col lg:flex-row gap-8" },
                    h(QuestionCard, {
                        currentQ,
                        currentIndex,
                        totalQuestions,
                        answer: answers[currentQ.id],
                        onAnswerChange: handleAnswerChange,
                        onNext: goToNext,
                        onPrev: goToPrev,
                        onSkip: markSkipped,
                        onReview: markReview
                    }),
                    h(QuestionPalette, {
                        questions: quizQuestions,
                        currentIndex,
                        statuses,
                        onSelect: setCurrentIndex,
                        stats,
                        answers
                    })
                )
            );
        }

        // --- Initialize App ---
        const rootElement = document.getElementById('root');
        if (rootElement) {
            const root = ReactDOM.createRoot(rootElement);
            root.render(h(ErrorBoundary, null, h(QuizApp)));
        }
    </script>
                    </body>

                    </html>