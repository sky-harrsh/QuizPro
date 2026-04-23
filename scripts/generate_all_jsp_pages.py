import os

navbar_html = """
<div class="nav">
    <a href="dashboard.jsp" title="Go to Dashboard" style="text-decoration: none; color: inherit;">
        <h2 style="margin:0;"><i class="fa-solid fa-graduation-cap"></i> QuizPro</h2>
    </a>
    <div style="display: flex; align-items: center; gap: 15px;">
        <a href="ProfileServlet" title="Go to Profile" style="text-decoration:none; display:flex; align-items:center; justify-content:center; width:35px; height:35px; border-radius:50%; background:linear-gradient(135deg, #667eea, #764ba2); color:white; font-weight:bold; box-shadow:0 2px 4px rgba(0,0,0,0.2);">
            <%= session.getAttribute("username") != null ? ((String)session.getAttribute("username")).substring(0,1).toUpperCase() : "U" %>
        </a>
        <button onclick="cycleTheme()" id="theme-btn" class="btn" style="background:transparent; border:1px solid rgba(255,255,255,0.3); padding: 5px 15px; border-radius: 5px; color: inherit; font-weight: bold;">🎨 Dark</button>
        <span style="display: flex; align-items: center;">Welcome, <%= session.getAttribute("username") %>!</span>
        <a href="LogoutServlet"><i class="fa-solid fa-sign-out-alt"></i> Logout</a>
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
.notes-container { max-width: 900px; margin: 0 auto; padding: 20px; }
.chapter-card { background: var(--bg-card, white); color: var(--text-color, #1e293b); border-radius: 8px; padding: 25px; margin-bottom: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
.chapter-title { color: var(--text-color, #1e293b); border-bottom: 2px solid var(--border-color, #e2e8f0); padding-bottom: 10px; margin-top: 0; }
pre, code { background: #1e293b; color: #f8fafc; padding: 10px; border-radius: 5px; overflow-x: auto; font-family: monospace; display: block;}
.take-quiz-btn { display: block; text-align: center; margin: 40px auto; padding: 15px 30px; background: #4f46e5; color: white; border-radius: 30px; text-decoration: none; font-size: 1.2rem; font-weight: bold; width: fit-content; transition: background 0.3s; }
.take-quiz-btn:hover { background: #4338ca; }
</style>
"""

def get_html(title, category, active_tab, content):
    tabs_html = """<div class="category-tabs">
    <a href="NotesServlet?category=core"     class="tab-btn {core_active}">☕ Core Java</a>
    <a href="NotesServlet?category=oop"      class="tab-btn {oop_active}">🧩 OOP Concepts</a>
    <a href="NotesServlet?category=advanced" class="tab-btn {adv_active}">⚡ Advanced Java</a>
    <a href="NotesServlet?category=misc"     class="tab-btn {misc_active}">📦 Miscellaneous</a>
</div>""".format(
        core_active="active" if active_tab=="core" else "",
        oop_active="active" if active_tab=="oop" else "",
        adv_active="active" if active_tab=="advanced" else "",
        misc_active="active" if active_tab=="misc" else ""
    )

    return f"""<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <title>{title} - QuizPro</title>
    <link rel="stylesheet" href="css/notes.css">
    <link rel="stylesheet" href="css/themes.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    {tabs_css}
</head>
<body>
{navbar_html}
{tabs_html}

<div class="notes-container">
{content}
</div>

<a href="QuizServlet?category={category}" class="take-quiz-btn">
    Ready? Take the {title} Quiz &rarr;
</a>

<script src="js/theme.js"></script>
</body>
</html>
"""

core_content = """
<div class="chapter-card">
    <h2 class="chapter-title">Chapter 1 — Introduction to Java</h2>
    <p><strong>History:</strong> Invented by James Gosling in 1995. Principle: WORA (Write Once, Run Anywhere).</p>
    <table border="1" cellpadding="5" cellspacing="0" style="width: 100%; border-collapse: collapse; margin-bottom: 15px;">
        <tr><th>Component</th><th>Meaning</th><th>Purpose</th></tr>
        <tr><td>JDK</td><td>Java Development Kit</td><td>Contains JRE + tools (javac) for development</td></tr>
        <tr><td>JRE</td><td>Java Runtime Environment</td><td>Contains JVM + libraries for execution</td></tr>
        <tr><td>JVM</td><td>Java Virtual Machine</td><td>Executes bytecode (platform-dependent)</td></tr>
    </table>
    <svg width="400" height="200" viewBox="0 0 400 200">
        <rect x="20" y="20" width="360" height="160" fill="#e2e8f0" stroke="#334155" />
        <text x="30" y="40" font-weight="bold" fill="#000">JDK</text>
        <rect x="40" y="50" width="260" height="120" fill="#cbd5e1" stroke="#334155" />
        <text x="50" y="70" font-weight="bold" fill="#000">JRE</text>
        <rect x="60" y="80" width="160" height="80" fill="#94a3b8" stroke="#334155" />
        <text x="70" y="100" font-weight="bold" fill="#000">JVM</text>
    </svg>
    <p><strong>Java Compilation Flow:</strong> <code>.java</code> &rarr; <code>javac</code> &rarr; <code>.class</code> &rarr; JVM &rarr; Output</p>
    <pre><code>public class HelloWorld {
    // Execution starts from main method
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
// Output: Hello, World!</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 2 — Data Types and Variables</h2>
    <ul>
        <li><code>byte</code>: 1B</li>
        <li><code>short</code>: 2B</li>
        <li><code>int</code>: 4B</li>
        <li><code>long</code>: 8B</li>
        <li><code>float</code>: 4B</li>
        <li><code>double</code>: 8B</li>
        <li><code>char</code>: 2B</li>
        <li><code>boolean</code>: 1 bit</li>
    </ul>
    <svg width="300" height="200" viewBox="0 0 300 200">
        <polygon points="150,20 280,180 20,180" fill="#e0f2fe" stroke="#0284c7" />
        <text x="150" y="60" text-anchor="middle" font-size="12" fill="#000">double (8B)</text>
        <text x="150" y="90" text-anchor="middle" font-size="12" fill="#000">float (4B)</text>
        <text x="150" y="120" text-anchor="middle" font-size="12" fill="#000">long (8B)</text>
        <text x="150" y="150" text-anchor="middle" font-size="12" fill="#000">int (4B)</text>
        <text x="150" y="170" text-anchor="middle" font-size="12" fill="#000">byte/short/char</text>
    </svg>
    <pre><code>// Widening casting (automatic)
int myInt = 9;
double myDouble = myInt; // Automatic casting: int to double

// Narrowing casting (manual)
double d = 9.78d;
int i = (int) d; // Manual casting: double to int

// Wrapper classes & Autoboxing
Integer wrapper = 10; // Autoboxing
int primitive = wrapper; // Unboxing</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 3 — Operators</h2>
    <p>Tables mapping operators (+, -, ==, !=, &&, ||, &, |) and precedence (postfix > prefix > unary > multiplicative > additive > relational > equality > logical > ternary > assignment).</p>
    <pre><code>// Step-by-step evaluation
int a = 10, b = 5, c = 20;
boolean res = (a > b) && (c > a) || (a == 10);
// (10 > 5) -> true
// (true) && (20 > 10) -> true && true -> true
// true || (true) -> true

// Short-circuit
if (a > c && (b++ > 0)) { }
// Since a > c is false, (b++ > 0) is never executed!</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 4 — Control Flow</h2>
    <svg width="200" height="200" viewBox="0 0 200 200">
        <polygon points="100,20 180,60 100,100 20,60" fill="#fef08a" stroke="#ca8a04"/>
        <text x="100" y="65" text-anchor="middle">Condition</text>
        <line x1="100" y1="100" x2="100" y2="150" stroke="#000" marker-end="url(#arrow)"/>
        <text x="110" y="125">True</text>
        <line x1="20" y1="60" x2="20" y2="150" stroke="#000" marker-end="url(#arrow)"/>
        <text x="30" y="110">False</text>
    </svg>
    <pre><code>// For loop dry run
for (int i = 1; i <= 5; i++) {
    if (i == 3) continue;
    if (i == 5) break;
    System.out.print(i + " ");
}
// Outputs: 1 2 4</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 5 — Arrays</h2>
    <svg width="300" height="100" viewBox="0 0 300 100">
        <rect x="10" y="30" width="40" height="40" fill="#fff" stroke="#000"/>
        <text x="30" y="55" text-anchor="middle" fill="#000">10</text>
        <text x="30" y="20" text-anchor="middle" font-size="10" fill="#000">[0]</text>
        <rect x="50" y="30" width="40" height="40" fill="#fff" stroke="#000"/>
        <text x="70" y="55" text-anchor="middle" fill="#000">20</text>
        <text x="70" y="20" text-anchor="middle" font-size="10" fill="#000">[1]</text>
    </svg>
    <pre><code>int[] arr = {4, 1, 9, -2, 5};
Arrays.sort(arr); // [-2, 1, 4, 5, 9]

// Find Max
int max = arr[0];
for(int n : arr) {
    if(n > max) max = n;
}
// Output: 9</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 6 — Strings</h2>
    <p>Strings are immutable (cannot be changed). The String pool optimizes memory usage.</p>
    <svg width="300" height="150" viewBox="0 0 300 150">
        <rect x="10" y="10" width="280" height="130" fill="#f8fafc" stroke="#64748b"/>
        <text x="150" y="30" text-anchor="middle" font-weight="bold" fill="#000">Heap Memory</text>
        <rect x="50" y="50" width="200" height="80" fill="#dbeafe" stroke="#3b82f6"/>
        <text x="150" y="70" text-anchor="middle" fill="#000">String Constants Pool</text>
        <text x="150" y="100" text-anchor="middle" fill="#000">"Hello"</text>
    </svg>
    <pre><code>String s = "Java";
s.concat(" 8"); // Returns new string but doesn't change 's'
System.out.println(s); // "Java"

StringBuilder sb = new StringBuilder("Java");
sb.append(" 8"); // Modifies in place!
System.out.println(sb); // "Java 8"</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 7 — Methods</h2>
    <pre><code>// Method Overloading
int add(int a, int b) { return a + b; }
double add(double a, double b) { return a + b; }

// Recursion: Factorial
int factorial(int n) {
    if (n == 0) return 1;
    return n * factorial(n - 1);
}
// factorial(3) -> 3 * factorial(2) ->... </code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 8 — Exception Handling</h2>
    <svg width="400" height="150" viewBox="0 0 400 150">
        <text x="200" y="20" text-anchor="middle" fill="#000">Throwable</text>
        <line x1="200" y1="30" x2="100" y2="60" stroke="#000" />
        <line x1="200" y1="30" x2="300" y2="60" stroke="#000" />
        <text x="100" y="80" text-anchor="middle" fill="#000">Error</text>
        <text x="300" y="80" text-anchor="middle" fill="#000">Exception</text>
        <line x1="300" y1="90" x2="250" y2="120" stroke="#000" />
        <line x1="300" y1="90" x2="350" y2="120" stroke="#000" />
        <text x="250" y="140" text-anchor="middle" fill="#000">RuntimeException</text>
        <text x="350" y="140" text-anchor="middle" fill="#000">IOException</text>
    </svg>
    <pre><code>try {
    int data = 50 / 0; // ArithmeticException
} catch (ArithmeticException e) {
    System.out.println(e);
} finally {
    System.out.println("Finally always executes");
}</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 9 — Collections Framework</h2>
    <p>List (ordered, duplicate), Set (unordered, unique), Map (Key-Value).</p>
    <pre><code>List&lt;String&gt; list = new ArrayList&lt;&gt;();
list.add("Java");
for(String s : list) System.out.println(s);

Map&lt;Integer, String&gt; map = new HashMap&lt;&gt;();
map.put(1, "Java");
map.put(2, "Python");
// Output mapping</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 10 — Java 8 Features</h2>
    <pre><code>// Lambda Syntax
List&lt;Integer&gt; nums = Arrays.asList(1, 2, 3, 4);
nums.forEach(n -> System.out.print(n + " "));

// Streams
List&lt;Integer&gt; even = nums.stream()
    .filter(n -> n % 2 == 0)
    .collect(Collectors.toList());</code></pre>
</div>
"""

advanced_content = """
<div class="chapter-card">
    <h2 class="chapter-title">Chapter 1 — Multithreading and Concurrency</h2>
    <svg width="500" height="100" viewBox="0 0 500 100">
        <rect x="10" y="30" width="80" height="40" fill="#f8fafc" stroke="#000"/>
        <text x="50" y="55" text-anchor="middle" fill="#000">New</text>
        <path d="M 90 50 L 130 50" stroke="#000" marker-end="url(#arrow)"/>
        <rect x="130" y="30" width="80" height="40" fill="#f8fafc" stroke="#000"/>
        <text x="170" y="55" text-anchor="middle" fill="#000">Runnable</text>
        <path d="M 210 50 L 250 50" stroke="#000" marker-end="url(#arrow)"/>
        <rect x="250" y="30" width="80" height="40" fill="#f8fafc" stroke="#000"/>
        <text x="290" y="55" text-anchor="middle" fill="#000">Running</text>
        <path d="M 330 50 L 370 50" stroke="#000" marker-end="url(#arrow)"/>
        <rect x="370" y="30" width="80" height="40" fill="#f8fafc" stroke="#000"/>
        <text x="410" y="55" text-anchor="middle" fill="#000">Dead</text>
    </svg>
    <pre><code>// Creating Threads (Runnable)
Thread t1 = new Thread(() -> {
    System.out.println("Running in thread: " + Thread.currentThread());
});
t1.start();

// Synchronized block to prevent race condition
public void increment() {
    synchronized(this) { count++; }
}</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 2 — JDBC (Database Connectivity)</h2>
    <svg width="500" height="100" viewBox="0 0 500 100">
        <text x="50" y="55" fill="#000">Java App</text>
        <text x="150" y="55" fill="#000">JDBC API</text>
        <text x="250" y="55" fill="#000">DriverManager</text>
        <text x="380" y="55" fill="#000">MySQL</text>
        <path d="M 100 50 L 140 50" stroke="#000"/>
        <path d="M 210 50 L 240 50" stroke="#000"/>
        <path d="M 340 50 L 370 50" stroke="#000"/>
    </svg>
    <pre><code>// 6 Steps to JDBC Connection
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/db", "root", "root");
PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id = ?");
ps.setInt(1, 1); // SQL injection prevention
ResultSet rs = ps.executeQuery();
while(rs.next()) { System.out.println(rs.getString("name")); }
con.close();</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 3 — Servlets</h2>
    <svg width="400" height="100" viewBox="0 0 400 100">
        <text x="50" y="50" fill="#000">init()</text>
        <text x="150" y="50" fill="#000">service()</text>
        <text x="250" y="50" fill="#000">doGet/doPost</text>
        <text x="350" y="50" fill="#000">destroy()</text>
    </svg>
    <pre><code>protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
    // Session Management
    HttpSession session = req.getSession();
    session.setAttribute("user", "admin");
    
    // RequestDispatcher redirect/forward
    // req.getRequestDispatcher("home.jsp").forward(req, res);
    res.getWriter().print("Hello Servlet!");
}</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 4 — JSP (Java Server Pages)</h2>
    <p>JSP translates into a Servlet eventually.</p>
    <pre><code>&lt;%@ page language="java" %&gt; &lt;!-- Directive --&gt;
&lt;%! int count = 0; %&gt; &lt;!-- Declaration --&gt;
&lt;% out.print(count); %&gt; &lt;!-- Scriptlet --&gt;
&lt;%= count %&gt; &lt;!-- Expression --&gt;

&lt;!-- JSTL --&gt;
&lt;c:forEach var="item" items="${list}"&gt;
    ${item.name}
&lt;/c:forEach&gt;</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 5 — Design Patterns</h2>
    <pre><code>// Singleton Pattern
public class Database {
    private static Database instance;
    private Database() {} // private constructor
    public static synchronized Database getInstance() {
        if(instance == null) instance = new Database();
        return instance;
    }
}

// Factory Pattern
ShapeFactory.getShape("CIRCLE").draw();</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 6 — Java Memory Model</h2>
    <p>Heap is for Objects, Stack is for execution frames. Garbage Collection clears unreferenced objects.</p>
    <pre><code>Object obj1 = new Object(); // 1. Heap Allocation
Object obj2 = obj1; // 2. Stack mapping to same heap memory
obj1 = null; 
// obj2 still holds memory -> Not ready for GC
obj2 = null;
// Memory unreachable -> Mark and Sweep reclaims it</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 7 — Generics</h2>
    <pre><code>// Generic Class implementing type safety
class Box&lt;T&gt; {
    private T item;
    public void set(T item) { this.item = item; }
    public T get() { return this.item; }
}

Box&lt;String&gt; sb = new Box&lt;&gt;();
sb.set("Hello"); // Type safe</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 8 — File I/O and Serialization</h2>
    <pre><code>// Read via NIO2
List&lt;String&gt; lines = Files.readAllLines(Paths.get("data.txt"));

// Serialization
ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream("obj.ser"));
out.writeObject(myUserObject); // Requires Serializable
out.close();
// transient fields are skipped</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 9 — Stream API Deep Dive</h2>
    <pre><code>List&lt;String&gt; names = Arrays.asList("John", "Doe", "Jack");
// Source -> Intermediate -> Terminal
names.stream()
     .filter(n -> n.startsWith("J")) // Intermediate
     .map(String::toUpperCase) // Intermediate
     .forEach(System.out::println); // Terminal</code></pre>
</div>

<div class="chapter-card">
    <h2 class="chapter-title">Chapter 10 — Spring Boot Basics</h2>
    <pre><code>@SpringBootApplication
@RestController
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }
    
    @GetMapping("/hello")
    public String hello() {
        return "Hello World API";
    }
}</code></pre>
</div>
"""

misc_content = """
<div class="chapter-card">
    <h2 class="chapter-title">Miscellaneous Topics in Java</h2>
    <p>This section covers supplementary topics that improve your engineering capability in Java but don't fall neatly into Core, OOP, or Advanced paths.</p>
    <ul>
        <li>Environment Variables & CLASSPATH configuration.</li>
        <li>Build tools like Maven and Gradle.</li>
        <li>Unit Testing with JUnit and Mockito.</li>
        <li>Regex (Regular Expressions) in Java (<code>java.util.regex</code>).</li>
        <li>Working with Dates and Times (<code>java.time.*</code>).</li>
    </ul>
    
    <h3>Regex Example</h3>
    <pre><code>import java.util.regex.*;
Pattern p = Pattern.compile("[a-zA-Z0-9]+@gmail\\.com");
Matcher m = p.matcher("contact@gmail.com");
if (m.matches()) {
    System.out.println("Valid Gmail Address");
}</code></pre>
</div>
"""

with open("c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/notes-core.jsp", "w", encoding="utf-8") as f:
    f.write(get_html("Core Java Notes", "core", "core", core_content))

with open("c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/notes-advanced.jsp", "w", encoding="utf-8") as f:
    f.write(get_html("Advanced Java Notes", "advanced", "advanced", advanced_content))

with open("c:/Users/Lenovo/OneDrive/Desktop/OnlineQuizSystem/WebContent/notes-misc.jsp", "w", encoding="utf-8") as f:
    f.write(get_html("Miscellaneous Notes", "misc", "misc", misc_content))
