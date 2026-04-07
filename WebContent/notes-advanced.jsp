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
    <title>Advanced Java Notes - QuizPro</title>
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

<div class="nav" style="padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; background: #fff; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
    <a href="dashboard.jsp" title="Go to Dashboard" style="text-decoration: none; color: inherit;">
        <h2 style="margin:0;"><i class="fa-solid fa-graduation-cap"></i> QuizPro</h2>
    </a>
    <div class="navbar-right">
    <button onclick="cycleTheme()" id="theme-btn" class="btn" style="background:transparent; border:1px solid #ddd; padding: 5px 15px; border-radius: 5px; color: inherit; font-weight: bold;">🎨 Dark</button>
    <a href="LogoutServlet" style="text-decoration: none; color: #e53e3e;"><i class="fa-solid fa-sign-out-alt"></i> Logout</a>
    <div class="profile-circle-wrapper">
        <a href="ProfileServlet" class="profile-circle" title="View Profile">
            <%= initial %>
        </a>
        <div class="profile-username-tag"><%= username %></div>
    </div>
</div></div>

<div class="category-tabs">
    <a href="NotesServlet?category=core"     class="tab-btn">&#9749; Core Java</a>
    <a href="NotesServlet?category=oop"      class="tab-btn">&#129529; OOP Concepts</a>
    <a href="NotesServlet?category=advanced" class="tab-btn active">&#9889; Advanced Java</a>
    <a href="NotesServlet?category=misc"     class="tab-btn">&#128230; Miscellaneous</a>
</div>

<div class="notes-container">

    <div class="reading-progress-container">
        <div class="reading-progress-bar" id="readingProgressBar"></div>
    </div>

    <div class="oop-book-container">
        <aside class="oop-sidebar">
            <div class="oop-sidebar-header">
                <span>&#128218; Chapters</span>
            </div>
            <div class="oop-book-tools">
                <button onclick="window.print()">&#128438; Print PDF</button>
                <button onclick="searchNotes()">&#128269; Search</button>
            </div>
            <ul class="chapter-nav-menu">
                <li class="chapter-nav-item"><a href="#adv-1" class="chapter-nav-link active" data-target="adv-1"><input type="checkbox" class="chapter-checkbox" id="adv-chk-1"> 1. Multithreading</a></li>
                <li class="chapter-nav-item"><a href="#adv-2" class="chapter-nav-link" data-target="adv-2"><input type="checkbox" class="chapter-checkbox" id="adv-chk-2"> 2. JDBC</a></li>
                <li class="chapter-nav-item"><a href="#adv-3" class="chapter-nav-link" data-target="adv-3"><input type="checkbox" class="chapter-checkbox" id="adv-chk-3"> 3. Servlets</a></li>
                <li class="chapter-nav-item"><a href="#adv-4" class="chapter-nav-link" data-target="adv-4"><input type="checkbox" class="chapter-checkbox" id="adv-chk-4"> 4. JSP</a></li>
                <li class="chapter-nav-item"><a href="#adv-5" class="chapter-nav-link" data-target="adv-5"><input type="checkbox" class="chapter-checkbox" id="adv-chk-5"> 5. Design Patterns</a></li>
                <li class="chapter-nav-item"><a href="#adv-6" class="chapter-nav-link" data-target="adv-6"><input type="checkbox" class="chapter-checkbox" id="adv-chk-6"> 6. Memory Model</a></li>
                <li class="chapter-nav-item"><a href="#adv-7" class="chapter-nav-link" data-target="adv-7"><input type="checkbox" class="chapter-checkbox" id="adv-chk-7"> 7. Generics</a></li>
                <li class="chapter-nav-item"><a href="#adv-8" class="chapter-nav-link" data-target="adv-8"><input type="checkbox" class="chapter-checkbox" id="adv-chk-8"> 8. File I/O</a></li>
                <li class="chapter-nav-item"><a href="#adv-9" class="chapter-nav-link" data-target="adv-9"><input type="checkbox" class="chapter-checkbox" id="adv-chk-9"> 9. Stream API</a></li>
                <li class="chapter-nav-item"><a href="#adv-10" class="chapter-nav-link" data-target="adv-10"><input type="checkbox" class="chapter-checkbox" id="adv-chk-10"> 10. Spring Boot Basics</a></li>
            </ul>
        </aside>

        <main class="oop-main-content">
            <div class="reading-meta">Estimated Reading Time: 50 Mins &bull; Advanced Java Track</div>

            <section id="adv-1" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 01</span>
                    <h2>Multithreading and Concurrency</h2>
                </div>
                <h3 class="oop-subheading">Thread Lifecycle and Synchronization</h3>
                <p class="oop-text">Java's multithreading model allows concurrent execution via the <code>Thread</code> class or <code>Runnable</code> interface. The JVM scheduler governs CPU time-slicing between runnable threads.</p>
                <div class="oop-diagram-box">
                    <svg width="500" height="100" viewBox="0 0 500 100">
                        <rect x="10" y="30" width="80" height="40" fill="#f8fafc" stroke="#000"/>
                        <text x="50" y="55" text-anchor="middle" fill="#000">New</text>
                        <path d="M 90 50 L 130 50" stroke="#000" marker-end="url(#arrow)"/>
                        <rect x="130" y="30" width="80" height="40" fill="#f8fafc" stroke="#000"/>
                        <text x="170" y="55" text-anchor="middle" fill="#000">Runnable</text>
                        <path d="M 210 50 L 250 50" stroke="#000" marker-end="url(#arrow)"/>
                        <rect x="250" y="30" width="80" height="40" fill="#bbf7d0" stroke="#15803d"/>
                        <text x="290" y="55" text-anchor="middle" fill="#000">Running</text>
                        <path d="M 330 50 L 370 50" stroke="#000" marker-end="url(#arrow)"/>
                        <rect x="370" y="30" width="80" height="40" fill="#fee2e2" stroke="#dc2626"/>
                        <text x="410" y="55" text-anchor="middle" fill="#000">Dead</text>
                    </svg>
                </div>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">// Creating Threads (Runnable)
Thread t1 = new Thread(() -&gt; {
    System.out.println("Running in: " + Thread.currentThread().getName());
});
t1.start();

// Synchronized block to prevent race condition
public synchronized void increment() {
    count++; // Only one thread at a time
}

// ExecutorService (modern approach)
ExecutorService pool = Executors.newFixedThreadPool(4);
pool.submit(() -&gt; System.out.println("Task from pool"));
pool.shutdown();</pre>
                </div>
                <div class="oop-summary-card">
                    <h3>Key Points - Multithreading</h3>
                    <ul>
                        <li><code>synchronized</code> prevents race conditions on shared resources.</li>
                        <li>Prefer <code>ExecutorService</code> over raw Thread creation for better resource management.</li>
                        <li><code>volatile</code> ensures visibility of variable changes across threads (no caching).</li>
                    </ul>
                </div>
            </section>

            <section id="adv-2" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 02</span>
                    <h2>JDBC (Database Connectivity)</h2>
                </div>
                <h3 class="oop-subheading">Connecting Java to Databases</h3>
                <p class="oop-text">JDBC (Java Database Connectivity) provides a standard API to connect Java programs to relational databases. It requires a driver, a connection, and SQL execution steps.</p>
                <div class="oop-diagram-box">
                    <svg width="500" height="80" viewBox="0 0 500 80">
                        <text x="30" y="45" fill="#000" font-weight="bold">Java App</text>
                        <path d="M 90 40 L 120 40" stroke="#000" marker-end="url(#arrow)"/>
                        <text x="125" y="45" fill="#000" font-weight="bold">JDBC API</text>
                        <path d="M 190 40 L 220 40" stroke="#000" marker-end="url(#arrow)"/>
                        <text x="225" y="45" fill="#000" font-weight="bold">DriverManager</text>
                        <path d="M 340 40 L 370 40" stroke="#000" marker-end="url(#arrow)"/>
                        <text x="375" y="45" fill="#3b82f6" font-weight="bold">MySQL</text>
                    </svg>
                </div>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">// 6 Steps to JDBC Connection
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/db", "root", "root");

PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM users WHERE id = ?");
ps.setInt(1, 1); // Prevents SQL Injection

ResultSet rs = ps.executeQuery();
while(rs.next()) {
    System.out.println(rs.getString("name"));
}
con.close();</pre>
                </div>
            </section>

            <section id="adv-3" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 03</span>
                    <h2>Servlets</h2>
                </div>
                <h3 class="oop-subheading">Servlet Lifecycle</h3>
                <p class="oop-text">A Servlet is a Java class that handles HTTP requests. It lives in a servlet container (like Apache Tomcat) and follows a strict lifecycle: <code>init()</code> &rarr; <code>service()</code> &rarr; <code>destroy()</code>.</p>
                <div class="oop-diagram-box">
                    <svg width="400" height="80" viewBox="0 0 400 80">
                        <text x="20" y="45" fill="#000">init()</text>
                        <path d="M 55 40 L 90 40" stroke="#000" marker-end="url(#arrow)"/>
                        <text x="95" y="45" fill="#000">service()</text>
                        <path d="M 160 40 L 195 40" stroke="#000" marker-end="url(#arrow)"/>
                        <text x="200" y="45" fill="#000">doGet/doPost</text>
                        <path d="M 295 40 L 330 40" stroke="#000" marker-end="url(#arrow)"/>
                        <text x="335" y="45" fill="#e55">destroy()</text>
                    </svg>
                </div>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession();
        session.setAttribute("userId", user.getId());
        session.setAttribute("username", user.getUsername());
        res.sendRedirect("dashboard.jsp");
    }
}</pre>
                </div>
            </section>

            <section id="adv-4" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 04</span>
                    <h2>JSP (Java Server Pages)</h2>
                </div>
                <h3 class="oop-subheading">JSP Elements and Implicit Objects</h3>
                <p class="oop-text">JSP allows embedding Java code into HTML pages. The JSP container translates JSP files into servlets before execution, making it server-side rendering technology.</p>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">&lt;%@ page language="java" %&gt; &lt;!-- Directive --&gt;
&lt;%! int count = 0; %&gt; &lt;!-- Declaration --&gt;
&lt;% out.print(count); %&gt; &lt;!-- Scriptlet --&gt;
&lt;%= count %&gt; &lt;!-- Expression --&gt;

&lt;!-- JSTL --&gt;
&lt;c:forEach var="item" items="${list}"&gt;
    ${item.name}
&lt;/c:forEach&gt;

&lt;!-- Implicit Objects: request, response, session, out, config --&gt;</pre>
                </div>
            </section>

            <section id="adv-5" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 05</span>
                    <h2>Design Patterns</h2>
                </div>
                <h3 class="oop-subheading">Singleton, Factory, Observer</h3>
                <p class="oop-text">Design patterns are reusable solutions to common software design problems. They are grouped into Creational, Structural, and Behavioral categories.</p>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">// Singleton Pattern
public class Database {
    private static Database instance;
    private Database() {} // private constructor
    public static synchronized Database getInstance() {
        if(instance == null) instance = new Database();
        return instance;
    }
}

// Factory Pattern
Shape shape = ShapeFactory.getShape("CIRCLE");
shape.draw();

// Observer Pattern
eventBus.subscribe("login", event -&gt; logAnalytics(event));</pre>
                </div>
                <div class="oop-summary-card">
                    <h3>Key Points - Design Patterns</h3>
                    <ul>
                        <li>Singleton ensures only one instance per JVM &mdash; critical for DB connection pools.</li>
                        <li>Factory decouples object creation from usage, enabling polymorphism.</li>
                        <li>Observer implements the publish-subscribe model for event-driven architectures.</li>
                    </ul>
                </div>
            </section>

            <section id="adv-6" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 06</span>
                    <h2>Java Memory Model</h2>
                </div>
                <h3 class="oop-subheading">Heap, Stack, Metaspace and GC</h3>
                <p class="oop-text">The JVM divides memory into: <strong>Heap</strong> (objects), <strong>Stack</strong> (execution frames per thread), <strong>Metaspace</strong> (class metadata). Garbage Collection automatically reclaims unreachable heap objects.</p>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">Object obj1 = new Object(); // 1. Heap Allocation
Object obj2 = obj1; // 2. Stack ref -> same heap block
obj1 = null;
// obj2 still references memory -> NOT ready for GC
obj2 = null;
// Both refs gone -> Mark and Sweep reclaims it

// Metaspace holds class definitions (not on heap)
// Use -XX:MaxMetaspaceSize to limit it</pre>
                </div>
            </section>

            <section id="adv-7" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 07</span>
                    <h2>Generics</h2>
                </div>
                <h3 class="oop-subheading">Type Safety at Compile Time</h3>
                <p class="oop-text">Generics enable classes/methods to operate on any type while retaining type safety. Generic types are erased at runtime (type erasure), but compile-time checks prevent ClassCastExceptions.</p>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">// Generic Class implementing type safety
class Box&lt;T&gt; {
    private T item;
    public void set(T item) { this.item = item; }
    public T get() { return this.item; }
}

Box&lt;String&gt; strBox = new Box&lt;&gt;();
strBox.set("Hello"); // Type safe

// Bounded Wildcards
public &lt;T extends Comparable&lt;T&gt;&gt; T max(T a, T b) {
    return a.compareTo(b) &gt;= 0 ? a : b;
}</pre>
                </div>
            </section>

            <section id="adv-8" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 08</span>
                    <h2>File I/O and Serialization</h2>
                </div>
                <h3 class="oop-subheading">NIO2, Serialization, Transient</h3>
                <p class="oop-text">Java provides classic I/O streams and the modern NIO2 API (java.nio.file) for file operations. Serialization converts objects to bytes for persistence or network transfer.</p>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">// Read via NIO2
List&lt;String&gt; lines = Files.readAllLines(Paths.get("data.txt"));
lines.forEach(System.out::println);

// Serialization
ObjectOutputStream out = new ObjectOutputStream(
    new FileOutputStream("obj.ser"));
out.writeObject(myUserObject); // Requires Serializable
out.close();

// transient fields are skipped during serialization
private transient String password; // won't be serialized</pre>
                </div>
            </section>

            <section id="adv-9" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 09</span>
                    <h2>Stream API Deep Dive</h2>
                </div>
                <h3 class="oop-subheading">Source &rarr; Intermediate &rarr; Terminal</h3>
                <p class="oop-text">The Stream API provides a declarative way to process collections. Streams are lazy &mdash; intermediate operations like <code>filter()</code> and <code>map()</code> are only executed when a terminal operation is invoked.</p>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">List&lt;String&gt; names = Arrays.asList("John", "Doe", "Jack");
// Source -> Intermediate -> Terminal
names.stream()
     .filter(n -&gt; n.startsWith("J")) // Intermediate
     .map(String::toUpperCase)        // Intermediate
     .sorted()                        // Intermediate
     .forEach(System.out::println);   // Terminal

// Collect
Map&lt;Boolean, List&lt;String&gt;&gt; partitioned = names.stream()
    .collect(Collectors.partitioningBy(n -&gt; n.length() &gt; 3));</pre>
                </div>
                <div class="oop-summary-card">
                    <h3>Key Points - Stream API</h3>
                    <ul>
                        <li>Streams don't store data &mdash; they operate on source collections.</li>
                        <li>Operations are lazily evaluated until a terminal operation like <code>collect()</code> triggers them.</li>
                        <li>Parallel streams (<code>parallelStream()</code>) leverage multi-core CPUs automatically.</li>
                    </ul>
                </div>
            </section>

            <section id="adv-10" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 10</span>
                    <h2>Spring Boot Basics</h2>
                </div>
                <h3 class="oop-subheading">Auto-configuration, REST APIs, Dependency Injection</h3>
                <p class="oop-text">Spring Boot is an opinionated framework built on Spring that eliminates boilerplate configuration. It provides embedded servers, auto-configuration, and production-ready features out of the box.</p>
                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:transparent;">@SpringBootApplication
@RestController
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }

    @GetMapping("/hello")
    public String hello() {
        return "Hello World API";
    }

    @PostMapping("/users")
    public ResponseEntity&lt;User&gt; createUser(@RequestBody User u) {
        return ResponseEntity.ok(userService.save(u));
    }
}

// application.properties
// spring.datasource.url=jdbc:mysql://localhost:3306/mydb</pre>
                </div>
                <div class="oop-summary-card">
                    <h3>Key Points - Spring Boot</h3>
                    <ul>
                        <li><code>@SpringBootApplication</code> combines @Configuration, @EnableAutoConfiguration, @ComponentScan.</li>
                        <li>Dependency Injection via <code>@Autowired</code> decouples class dependencies.</li>
                        <li>Spring Data JPA eliminates boilerplate DAO/Repository code with just an interface.</li>
                    </ul>
                </div>
            </section>

            <a href="QuizServlet?category=advanced" class="take-quiz-btn">
                Ready? Take the Advanced Java Notes Quiz &rarr;
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
    localStorage.setItem('notes_advanced_' + id, checked);
}
function loadProgress() {
    document.querySelectorAll('.chapter-checkbox').forEach(cb => {
        const saved = localStorage.getItem('notes_advanced_' + cb.id);
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
    const term = prompt('Search Advanced Java notes:');
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
