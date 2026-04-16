<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = "";
    String initial = "U";
    if (session.getAttribute("username") != null) {
        username = (String) session.getAttribute("username");
        if (!username.isEmpty()) {
            initial = String.valueOf(username.charAt(0)).toUpperCase();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Core Java Notes - QuizPro</title>
    <link rel="stylesheet" href="css/notes.css">
    <link rel="stylesheet" href="css/oop-notes.css">
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
.notes-container { max-width: 1400px; margin: 0 auto; padding: 20px; }
.take-quiz-btn { display: block; text-align: center; margin: 40px auto; padding: 15px 30px; background: #4f46e5; color: white; border-radius: 30px; text-decoration: none; font-size: 1.2rem; font-weight: bold; width: fit-content; transition: background 0.3s; }
.take-quiz-btn:hover { background: #4338ca; }
pre, code { background: #1e293b; color: #f8fafc; padding: 10px; border-radius: 5px; overflow-x: auto; font-family: monospace; display: block;}
</style>

</head>
<body>

<div class="nav" style="padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <a href="dashboard.jsp" title="Go to Dashboard" style="text-decoration: none;">
        <h2 style="margin:0; color: #ffffff;"><i class="fa-solid fa-graduation-cap" style="color: #ffffff;"></i> QuizPro</h2>
    </a>
    <div class="navbar-right">
    <button onclick="cycleTheme()" id="theme-btn" class="btn" style="color: #ffffff; border: 1px solid rgba(255,255,255,0.4); background: transparent; padding: 5px 15px; border-radius: 5px; font-weight: bold;">🎨 Dark</button>
    <a href="LogoutServlet" style="color: #ff6b6b; text-decoration:none;"><i class="fa-solid fa-sign-out-alt"></i> Logout</a>
    <div class="profile-circle-wrapper">
        <a href="ProfileServlet" class="profile-circle" title="View Profile">
            <%= initial %>
        </a>
        <div class="profile-username-tag" style="color: #ffffff;"><%= username %></div>
    </div>
</div></div>

<div class="category-tabs">
    <a href="NotesServlet?category=core"     class="tab-btn active">&#9749; Core Java</a>
    <a href="NotesServlet?category=oop"      class="tab-btn">&#129529; OOP Concepts</a>
    <a href="NotesServlet?category=advanced" class="tab-btn">&#9889; Advanced Java</a>
    <a href="NotesServlet?category=misc"     class="tab-btn">&#128230; Miscellaneous</a>
</div>

<div class="notes-container">

    <div class="reading-progress-container">
        <div class="reading-progress-bar" id="readingProgressBar"></div>
    </div>

    <div class="oop-book-container" style="background: #ffffff;">
        <aside class="oop-sidebar">
            <div class="oop-sidebar-header">
                <span>&#128218; Chapters</span>
            </div>
            <div class="oop-book-tools">
                <button onclick="window.print()">&#128438; Print PDF</button>
                <button onclick="searchNotes()">&#128269; Search</button>
            </div>
            <ul class="chapter-nav-menu">
                <li class="chapter-nav-item"><a href="#chapter-1" class="chapter-nav-link active" data-target="chapter-1"><input type="checkbox" class="chapter-checkbox" id="chk-1"> 1. Intro to Java</a></li>
                <li class="chapter-nav-item"><a href="#chapter-2" class="chapter-nav-link" data-target="chapter-2"><input type="checkbox" class="chapter-checkbox" id="chk-2"> 2. Data Types</a></li>
                <li class="chapter-nav-item"><a href="#chapter-3" class="chapter-nav-link" data-target="chapter-3"><input type="checkbox" class="chapter-checkbox" id="chk-3"> 3. Operators</a></li>
                <li class="chapter-nav-item"><a href="#chapter-4" class="chapter-nav-link" data-target="chapter-4"><input type="checkbox" class="chapter-checkbox" id="chk-4"> 4. Control Flow</a></li>
                <li class="chapter-nav-item"><a href="#chapter-5" class="chapter-nav-link" data-target="chapter-5"><input type="checkbox" class="chapter-checkbox" id="chk-5"> 5. Arrays</a></li>
                <li class="chapter-nav-item"><a href="#chapter-6" class="chapter-nav-link" data-target="chapter-6"><input type="checkbox" class="chapter-checkbox" id="chk-6"> 6. Strings</a></li>
                <li class="chapter-nav-item"><a href="#chapter-7" class="chapter-nav-link" data-target="chapter-7"><input type="checkbox" class="chapter-checkbox" id="chk-7"> 7. Methods</a></li>
                <li class="chapter-nav-item"><a href="#chapter-8" class="chapter-nav-link" data-target="chapter-8"><input type="checkbox" class="chapter-checkbox" id="chk-8"> 8. Exception Handling</a></li>
                <li class="chapter-nav-item"><a href="#chapter-9" class="chapter-nav-link" data-target="chapter-9"><input type="checkbox" class="chapter-checkbox" id="chk-9"> 9. Collections</a></li>
                <li class="chapter-nav-item"><a href="#chapter-10" class="chapter-nav-link" data-target="chapter-10"><input type="checkbox" class="chapter-checkbox" id="chk-10"> 10. Java 8 Features</a></li>
            </ul>
        </aside>

        <main class="oop-main-content">
            <div class="reading-meta">Estimated Reading Time: 45 Mins &bull; Core Java Track</div>

            <section id="chapter-1" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 01</span>
                    <h2>Introduction to Java</h2>
                </div>
                <p class="oop-text"><strong>History:</strong> Invented by James Gosling in 1995. Principle: WORA (Write Once, Run Anywhere).</p>
                <table border="1" cellpadding="5" cellspacing="0" style="width: 100%; border-collapse: collapse; margin-bottom: 15px;">
                    <tr><th>Component</th><th>Meaning</th><th>Purpose</th></tr>
                    <tr><td>JDK</td><td>Java Development Kit</td><td>Contains JRE + tools (javac) for development</td></tr>
                    <tr><td>JRE</td><td>Java Runtime Environment</td><td>Contains JVM + libraries for execution</td></tr>
                    <tr><td>JVM</td><td>Java Virtual Machine</td><td>Executes bytecode (platform-dependent)</td></tr>
                </table>
                <div class="oop-diagram-box">
                    <svg width="400" height="200" viewBox="0 0 400 200">
                        <rect x="20" y="20" width="360" height="160" fill="#e2e8f0" stroke="#334155" />
                        <text x="30" y="40" font-weight="bold" fill="#000">JDK</text>
                        <rect x="40" y="50" width="260" height="120" fill="#cbd5e1" stroke="#334155" />
                        <text x="50" y="70" font-weight="bold" fill="#000">JRE</text>
                        <rect x="60" y="80" width="160" height="80" fill="#94a3b8" stroke="#334155" />
                        <text x="70" y="100" font-weight="bold" fill="#000">JVM</text>
                    </svg>
                </div>
                <p class="oop-text"><strong>Java Compilation Flow:</strong> <code>.java</code> &rarr; <code>javac</code> &rarr; <code>.class</code> &rarr; JVM &rarr; Output</p>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">public class HelloWorld {
    // Execution starts from main method
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
// Output: Hello, World!</pre>
                </div>
            </section>

            <section id="chapter-2" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 02</span>
                    <h2>Data Types and Variables</h2>
                </div>
                <h3 class="oop-subheading">Primitive Types</h3>
                <ul class="oop-text" style="list-style:disc; padding-left:1.5rem;">
                    <li><code>byte</code>: 1B &mdash; <code>short</code>: 2B &mdash; <code>int</code>: 4B &mdash; <code>long</code>: 8B</li>
                    <li><code>float</code>: 4B &mdash; <code>double</code>: 8B &mdash; <code>char</code>: 2B &mdash; <code>boolean</code>: 1 bit</li>
                </ul>
                <div class="oop-diagram-box">
                    <svg width="300" height="200" viewBox="0 0 300 200">
                        <polygon points="150,20 280,180 20,180" fill="#e0f2fe" stroke="#0284c7" />
                        <text x="150" y="60" text-anchor="middle" font-size="12" fill="#000">double (8B)</text>
                        <text x="150" y="90" text-anchor="middle" font-size="12" fill="#000">float (4B)</text>
                        <text x="150" y="120" text-anchor="middle" font-size="12" fill="#000">long (8B)</text>
                        <text x="150" y="150" text-anchor="middle" font-size="12" fill="#000">int (4B)</text>
                        <text x="150" y="170" text-anchor="middle" font-size="12" fill="#000">byte/short/char</text>
                    </svg>
                </div>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">// Widening casting (automatic)
int myInt = 9;
double myDouble = myInt; // int to double

// Narrowing casting (manual)
double d = 9.78d;
int i = (int) d; // double to int

// Wrapper classes &amp; Autoboxing
Integer wrapper = 10; // Autoboxing
int primitive = wrapper; // Unboxing</pre>
                </div>
            </section>

            <section id="chapter-3" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 03</span>
                    <h2>Operators</h2>
                </div>
                <p class="oop-text">Operators (+, -, ==, !=, &amp;&amp;, ||, &amp;, |) and precedence: postfix &gt; prefix &gt; unary &gt; multiplicative &gt; additive &gt; relational &gt; equality &gt; logical &gt; ternary &gt; assignment.</p>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">// Step-by-step evaluation
int a = 10, b = 5, c = 20;
boolean res = (a > b) &amp;&amp; (c > a) || (a == 10);
// (10 > 5) -> true
// (true) &amp;&amp; (20 > 10) -> true &amp;&amp; true -> true
// true || (true) -> true

// Short-circuit
if (a > c &amp;&amp; (b++ > 0)) { }
// Since a > c is false, (b++ > 0) is never executed!</pre>
                </div>
            </section>

            <section id="chapter-4" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 04</span>
                    <h2>Control Flow</h2>
                </div>
                <h3 class="oop-subheading">if/else, switch, loops</h3>
                <div class="oop-diagram-box">
                    <svg width="200" height="200" viewBox="0 0 200 200">
                        <polygon points="100,20 180,60 100,100 20,60" fill="#fef08a" stroke="#ca8a04"/>
                        <text x="100" y="65" text-anchor="middle">Condition</text>
                        <line x1="100" y1="100" x2="100" y2="150" stroke="#000" marker-end="url(#arrow)"/>
                        <text x="110" y="125">True</text>
                        <line x1="20" y1="60" x2="20" y2="150" stroke="#000" marker-end="url(#arrow)"/>
                        <text x="30" y="110">False</text>
                    </svg>
                </div>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">// For loop dry run
for (int i = 1; i &lt;= 5; i++) {
    if (i == 3) continue;
    if (i == 5) break;
    System.out.print(i + " ");
}
// Outputs: 1 2 4</pre>
                </div>
            </section>

            <section id="chapter-5" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 05</span>
                    <h2>Arrays</h2>
                </div>
                <h3 class="oop-subheading">Single and Multi-dimensional Arrays</h3>
                <div class="oop-diagram-box">
                    <svg width="300" height="100" viewBox="0 0 300 100">
                        <rect x="10" y="30" width="40" height="40" fill="#fff" stroke="#000"/>
                        <text x="30" y="55" text-anchor="middle" fill="#000">10</text>
                        <text x="30" y="20" text-anchor="middle" font-size="10" fill="#000">[0]</text>
                        <rect x="50" y="30" width="40" height="40" fill="#fff" stroke="#000"/>
                        <text x="70" y="55" text-anchor="middle" fill="#000">20</text>
                        <text x="70" y="20" text-anchor="middle" font-size="10" fill="#000">[1]</text>
                        <rect x="90" y="30" width="40" height="40" fill="#fff" stroke="#000"/>
                        <text x="110" y="55" text-anchor="middle" fill="#000">30</text>
                        <text x="110" y="20" text-anchor="middle" font-size="10" fill="#000">[2]</text>
                    </svg>
                </div>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">int[] arr = {4, 1, 9, -2, 5};
Arrays.sort(arr); // [-2, 1, 4, 5, 9]

// Find Max
int max = arr[0];
for(int n : arr) {
    if(n > max) max = n;
}
// Output: 9</pre>
                </div>
            </section>

            <section id="chapter-6" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 06</span>
                    <h2>Strings</h2>
                </div>
                <h3 class="oop-subheading">Immutability and String Pool</h3>
                <p class="oop-text">Strings are immutable (cannot be changed). The String pool optimizes memory usage by reusing literal references.</p>
                <div class="oop-diagram-box">
                    <svg width="300" height="150" viewBox="0 0 300 150">
                        <rect x="10" y="10" width="280" height="130" fill="#f8fafc" stroke="#64748b"/>
                        <text x="150" y="30" text-anchor="middle" font-weight="bold" fill="#000">Heap Memory</text>
                        <rect x="50" y="50" width="200" height="80" fill="#dbeafe" stroke="#3b82f6"/>
                        <text x="150" y="70" text-anchor="middle" fill="#000">String Constants Pool</text>
                        <text x="150" y="100" text-anchor="middle" fill="#000">"Hello"</text>
                    </svg>
                </div>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">String s = "Java";
s.concat(" 8"); // Returns new string but doesn't change 's'
System.out.println(s); // "Java"

StringBuilder sb = new StringBuilder("Java");
sb.append(" 8"); // Modifies in place!
System.out.println(sb); // "Java 8"</pre>
                </div>
            </section>

            <section id="chapter-7" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 07</span>
                    <h2>Methods</h2>
                </div>
                <h3 class="oop-subheading">Overloading and Recursion</h3>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">// Method Overloading
int add(int a, int b) { return a + b; }
double add(double a, double b) { return a + b; }

// Recursion: Factorial
int factorial(int n) {
    if (n == 0) return 1;
    return n * factorial(n - 1);
}
// factorial(3) -> 3 * factorial(2) -> 3 * 2 * factorial(1) -> 6</pre>
                </div>
            </section>

            <section id="chapter-8" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 08</span>
                    <h2>Exception Handling</h2>
                </div>
                <h3 class="oop-subheading">Try-Catch-Finally and Custom Exceptions</h3>
                <div class="oop-diagram-box">
                    <svg width="400" height="150" viewBox="0 0 400 150">
                        <text x="200" y="20" text-anchor="middle" fill="#000" font-weight="bold">Throwable</text>
                        <line x1="200" y1="30" x2="100" y2="60" stroke="#000" />
                        <line x1="200" y1="30" x2="300" y2="60" stroke="#000" />
                        <text x="100" y="80" text-anchor="middle" fill="#e55">Error</text>
                        <text x="300" y="80" text-anchor="middle" fill="#000">Exception</text>
                        <line x1="300" y1="90" x2="250" y2="120" stroke="#000" />
                        <line x1="300" y1="90" x2="350" y2="120" stroke="#000" />
                        <text x="210" y="140" text-anchor="middle" fill="#000">RuntimeException</text>
                        <text x="360" y="140" text-anchor="middle" fill="#000">IOException</text>
                    </svg>
                </div>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">try {
    int data = 50 / 0; // ArithmeticException
} catch (ArithmeticException e) {
    System.out.println(e);
} finally {
    System.out.println("Finally always executes");
}</pre>
                </div>
            </section>

            <section id="chapter-9" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 09</span>
                    <h2>Collections Framework</h2>
                </div>
                <h3 class="oop-subheading">List, Set, Map</h3>
                <p class="oop-text"><strong>List</strong> (ordered, allows duplicates) &mdash; <strong>Set</strong> (unordered, unique) &mdash; <strong>Map</strong> (Key-Value pairs).</p>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">List&lt;String&gt; list = new ArrayList&lt;&gt;();
list.add("Java");
for(String s : list) System.out.println(s);

Map&lt;Integer, String&gt; map = new HashMap&lt;&gt;();
map.put(1, "Java");
map.put(2, "Python");
// Outputs key-value mapping</pre>
                </div>
            </section>

            <section id="chapter-10" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 10</span>
                    <h2>Java 8 Features</h2>
                </div>
                <h3 class="oop-subheading">Lambda, Stream API, Optional</h3>
                <p class="oop-text">Java 8 introduced functional programming styles via lambda expressions and the Stream API, making code concise and expressive.</p>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">// Lambda Syntax
List&lt;Integer&gt; nums = Arrays.asList(1, 2, 3, 4);
nums.forEach(n -&gt; System.out.print(n + " "));

// Streams
List&lt;Integer&gt; even = nums.stream()
    .filter(n -&gt; n % 2 == 0)
    .collect(Collectors.toList());
// even = [2, 4]

// Optional
Optional&lt;String&gt; opt = Optional.ofNullable(null);
System.out.println(opt.orElse("default")); // default</pre>
                </div>
                <div class="oop-summary-card">
                    <h3>Key Points - Java 8 Features</h3>
                    <ul>
                        <li>Lambdas replace verbose anonymous inner class implementations.</li>
                        <li>Streams chain operations lazily — only evaluated at terminal operations.</li>
                        <li>Optional prevents NullPointerExceptions at API boundaries.</li>
                    </ul>
                </div>
            </section>

            <a href="QuizServlet?category=core" class="take-quiz-btn">
                Ready? Take the Core Java Notes Quiz &rarr;
            </a>

        </main>
    </div>
</div>

<button id="scrollTopBtn" onclick="window.scrollTo({top:0,behavior:'smooth'})"
    style="display:none; position:fixed; bottom:32px; right:32px;
           width:48px; height:48px; border-radius:50%;
           background:linear-gradient(135deg,#667eea,#764ba2);
           color:white; font-size:20px; border:none; cursor:pointer;
           box-shadow:0 4px 15px rgba(102,126,234,0.4); z-index:999;">
    &#8679;
</button>

<div id="scrollProgress"
    style="position:fixed; top:0; left:0; height:3px; width:0%;
           background:linear-gradient(90deg,#667eea,#764ba2);
           z-index:9999; transition:width 0.1s;">
</div>

<script src="js/theme.js"></script>
<script>
// Reading progress bar
window.addEventListener('scroll', function() {
    const winScroll = document.documentElement.scrollTop || document.body.scrollTop;
    const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    const scrolled = height > 0 ? (winScroll / height) * 100 : 0;
    const prog = document.getElementById('scrollProgress');
    if(prog) prog.style.width = scrolled + '%';
    const bar = document.getElementById('readingProgressBar');
    if(bar) bar.style.width = scrolled + '%';
    const btn = document.getElementById('scrollTopBtn');
    if (window.scrollY > 300) btn.style.display = 'block';
    else btn.style.display = 'none';
});

// Intersection Observer: highlight sidebar item on scroll
const sections = document.querySelectorAll('.oop-chapter');
const navLinks = document.querySelectorAll('.chapter-nav-link');

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            navLinks.forEach(link => link.classList.remove('active'));
            const id = entry.target.getAttribute('id');
            const activeLink = document.querySelector('.chapter-nav-link[data-target="' + id + '"]');
            if (activeLink) activeLink.classList.add('active');
        }
    });
}, { threshold: 0.3 });

sections.forEach(section => observer.observe(section));

// Sidebar anchor click
navLinks.forEach(link => {
    link.addEventListener('click', function(e) {
        const targetId = this.getAttribute('data-target');
        if (targetId) {
            e.preventDefault();
            const el = document.getElementById(targetId);
            if (el) el.scrollIntoView({ behavior: 'smooth' });
        }
    });
});

// Checkbox progress: save/restore via localStorage
function saveProgress(id, checked) {
    localStorage.setItem('notes_core_' + id, checked);
}
function loadProgress() {
    document.querySelectorAll('.chapter-checkbox').forEach(cb => {
        const saved = localStorage.getItem('notes_core_' + cb.id);
        if (saved === 'true') cb.checked = true;
    });
}
document.querySelectorAll('.chapter-checkbox').forEach(cb => {
    cb.addEventListener('change', function() {
        saveProgress(this.id, this.checked);
    });
});
document.addEventListener('DOMContentLoaded', loadProgress);
loadProgress();

function searchNotes() {
    const term = prompt('Search Core Java notes:');
    if (!term) return;
    document.querySelectorAll('.oop-highlight').forEach(el => {
        el.outerHTML = el.innerHTML;
    });
    if (!term.trim()) return;
    const main = document.querySelector('.oop-main-content');
    const walker = document.createTreeWalker(main, NodeFilter.SHOW_TEXT);
    const regex = new RegExp('(' + term.replace(/[.*+?^\${}()|[\]\\]/g, '\\$&') + ')', 'gi');
    let node;
    const toReplace = [];
    while (node = walker.nextNode()) {
        if (regex.test(node.nodeValue)) toReplace.push(node);
    }
    toReplace.forEach(n => {
        const span = document.createElement('span');
        span.innerHTML = n.nodeValue.replace(regex, '<span class="oop-highlight">$1</span>');
        n.parentNode.replaceChild(span, n);
    });
}
</script>
</body>
</html>
