<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>OOP Concepts Notes - QuizPro</title>
    <link rel="stylesheet" href="css/notes.css">
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
    <%
        String username = "";
        String initial = "U";
        if (session != null && session.getAttribute("username") != null) {
            username = (String) session.getAttribute("username");
            if (username != null && !username.isEmpty()) {
                initial = String.valueOf(username.charAt(0)).toUpperCase();
            }
        }
    %>
    <div class="profile-circle-wrapper">
        <a href="ProfileServlet" class="profile-circle" title="View Profile">
            <%= initial %>
        </a>
        <div class="profile-username-tag" style="color: #ffffff;"><%= username %></div>
    </div>
</div></div>

<div class="category-tabs">
    <a href="NotesServlet?category=core"     class="tab-btn">☕ Core Java</a>
    <a href="NotesServlet?category=oop"      class="tab-btn active">🧩 OOP Concepts</a>
    <a href="NotesServlet?category=advanced" class="tab-btn">⚡ Advanced Java</a>
    <a href="NotesServlet?category=misc"     class="tab-btn">📦 Miscellaneous</a>
</div>

<div class="notes-container">

    <link rel="stylesheet" href="css/oop-notes.css">

    <div class="reading-progress-container">
        <div class="reading-progress-bar" id="readingProgressBar"></div>
    </div>

    <div class="oop-book-container" style="background: #ffffff; display: flex; max-width: 1400px; margin: 0 auto;">
        <aside class="oop-sidebar" style="width: 320px;">
            <div class="oop-sidebar-header">
                <span>📚 Chapters</span>
            </div>
            <div class="oop-book-tools">
                <button onclick="window.print()">🖨️ Print PDF</button>
                <button onclick="searchNotes()">🔍 Search</button>
            </div>
            <ul class="chapter-nav-menu">
                <li class="chapter-nav-item"><a href="#chapter-1" class="chapter-nav-link active"
                        data-target="chapter-1"><input type="checkbox" class="chapter-checkbox" id="chk-1"> 1. Intro to
                        OOP</a></li>
                <li class="chapter-nav-item"><a href="#chapter-2" class="chapter-nav-link"
                        data-target="chapter-2"><input type="checkbox" class="chapter-checkbox" id="chk-2"> 2. Classes &
                        Objects</a></li>
                <li class="chapter-nav-item"><a href="#chapter-3" class="chapter-nav-link"
                        data-target="chapter-3"><input type="checkbox" class="chapter-checkbox" id="chk-3"> 3.
                        Encapsulation</a></li>
                <li class="chapter-nav-item"><a href="#chapter-4" class="chapter-nav-link"
                        data-target="chapter-4"><input type="checkbox" class="chapter-checkbox" id="chk-4"> 4.
                        Inheritance</a></li>
                <li class="chapter-nav-item"><a href="#chapter-5" class="chapter-nav-link"
                        data-target="chapter-5"><input type="checkbox" class="chapter-checkbox" id="chk-5"> 5.
                        Polymorphism</a></li>
                <li class="chapter-nav-item"><a href="#chapter-6" class="chapter-nav-link"
                        data-target="chapter-6"><input type="checkbox" class="chapter-checkbox" id="chk-6"> 6.
                        Abstraction</a></li>
                <li class="chapter-nav-item"><a href="#chapter-7" class="chapter-nav-link"
                        data-target="chapter-7"><input type="checkbox" class="chapter-checkbox" id="chk-7"> 7.
                        Interfaces (Deep Dive)</a></li>
                <li class="chapter-nav-item"><a href="#chapter-8" class="chapter-nav-link"
                        data-target="chapter-8"><input type="checkbox" class="chapter-checkbox" id="chk-8"> 8. Advanced
                        OOP</a></li>
                <li class="chapter-nav-item"><a href="#chapter-9" class="chapter-nav-link"
                        data-target="chapter-9"><input type="checkbox" class="chapter-checkbox" id="chk-9"> 9. SOLID
                        Principles</a></li>
                <li class="chapter-nav-item"><a href="#chapter-10" class="chapter-nav-link"
                        data-target="chapter-10"><input type="checkbox" class="chapter-checkbox" id="chk-10"> 10. Design
                        Patterns</a></li>
            </ul>
        </aside>

        <main class="oop-main-content" style="flex: 1;">
            <div class="reading-meta">Estimated Reading Time: 50 Mins &bull; Advanced Engineering Track</div>

            <section id="chapter-1" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 01</span>
                    <h2>Introduction to OOP</h2>
                </div>
                <h3 class="oop-subheading">What is OOP?</h3>
                <p class="oop-text">Object-Oriented Programming (OOP) is a programming paradigm built around the concept
                    of "objects", which encompass both state (data) and behavior (methods). Originally developed as a
                    response to the inflexible nature of procedural programming, OOP evolved through languages like
                    Simula and Smalltalk before being widely popularized by C++ and Java. The shift towards OOP
                    revolutionized the software engineering landscape.</p>
                <p class="oop-text">Unlike procedural architectures, where logic consists of detached procedures passing
                    shared variables back and forth (often leading to spaghetti code), OOP encapsulates data into highly
                    cohesive modules. A real-world analogy is a car engine: you interact with the ignition system
                    without constantly thinking about the fuel injector states. The internal mechanism manages its own
                    data securely behind an abstraction layer.</p>
                <p class="oop-text">The Four Pillars of OOP natively dictate system architectures: Encapsulation
                    (securing states inside protective boundaries), Inheritance (adopting pre-existing capabilities),
                    Polymorphism (morphing behavior dynamically at runtime), and Abstraction (exposing only essential
                    usability while shielding complexity). A solid understanding of these four pillars transforms a
                    standard coder into a software architect.</p>

                <div class="oop-diagram-box">
                    <svg width="500" height="200" viewBox="0 0 500 200">
                        <rect x="50" y="20" width="120" height="150" fill="#f8fafc" stroke="#3b82f6" stroke-width="2"
                            rx="10" />
                        <text x="110" y="50" font-family="sans-serif" font-weight="bold" text-anchor="middle"
                            fill="#1e3a8a">Class Diagram</text>
                        <text x="110" y="80" font-family="sans-serif" font-size="12" text-anchor="middle">Blueprint:
                            State</text>
                        <text x="110" y="110" font-family="sans-serif" font-size="12" text-anchor="middle">Blueprint:
                            Behavior</text>

                        <line x1="180" y1="95" x2="280" y2="60" stroke="#94a3b8" stroke-width="2"
                            stroke-dasharray="4" />
                        <line x1="180" y1="95" x2="280" y2="130" stroke="#94a3b8" stroke-width="2"
                            stroke-dasharray="4" />

                        <rect x="300" y="20" width="120" height="60" fill="#dbeafe" stroke="#2563eb" stroke-width="2"
                            rx="10" />
                        <text x="360" y="45" font-family="sans-serif" font-weight="bold" text-anchor="middle"
                            fill="#1e3a8a">Heap Object 1</text>

                        <rect x="300" y="100" width="120" height="60" fill="#dbeafe" stroke="#2563eb" stroke-width="2"
                            rx="10" />
                        <text x="360" y="125" font-family="sans-serif" font-weight="bold" text-anchor="middle"
                            fill="#1e3a8a">Heap Object 2</text>
                    </svg>
                </div>

                <h3 class="oop-subheading">Class vs Object and Memory Allocation</h3>
                <p class="oop-text">A <code>Class</code> is a logical prototype. It exists merely in the
                    Metaspace/Method Area during JVM execution and consumes negligible memory. However, an
                    <code>Object</code> represents an allocated cluster of bits occupying literal Random Access Memory
                    in the Heap space. When you type the <code>new</code> keyword, the JVM immediately scouts the HEAP
                    for an unmapped block of free bytes. The constructor explicitly initializes that memory block.
                    Constructor chaining enables sequential, orchestrated configuration of complex structures before
                    yielding the finalized object reference to the Stack.</p>

                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:#1e293b;padding:15px;border-radius:8px;"><code>// Step 1: Memory request via 'new' -> JVM Heap
// Step 2: Constructor initializes fields
// Step 3: Stack reference stored
Car myHonda = new Car("Civic", 2024);

// Dry Run Flow:
> Stack pointer 'myHonda' created
> Heap allocates ~128 bytes
> Car(String, int) constructor fired
> myHonda -> [Memory Address 0x8FA4]
</code></pre>
                </div>

                <br>
                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Example 1: Your first class and object</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">public</span> <span class="kw">class</span> <span class="cl">Car</span> {</span>
<span class="line">    <span class="kw"><span class="cl">String</span></span> brand;</span>
<span class="line">    <span class="kw">int</span> speed;</span>
<span class="line"></span>
<span class="line">    <span class="kw">void</span> <span class="mt">accelerate</span>() {</span>
<span class="line">        speed += <span <span class="kw">class</span>="nm">10</span>;</span>
<span class="line">        <span class="cl">System</span>.out.<span class="mt">println</span>(brand + <span <span class="kw">class</span>="st">" is now going "</span> + speed + <span <span class="kw">class</span>="st">" km/h"</span>);</span>
<span class="line">    }</span>
<span class="line"></span>
<span class="line">    <span class="kw">public</span> <span class="kw">static</span> <span class="kw">void</span> <span class="mt">main</span>(<span class="kw"><span class="cl">String</span></span>[] args) {</span>
<span class="line">        <span class="cl">Car</span> myCar = <span class="kw">new</span> <span class="cl">Car</span>();</span>
<span class="line">        myCar.brand = <span <span class="kw">class</span>="st">"<span class="cl">Toyota</span>"</span>;</span>
<span class="line">        myCar.speed = <span <span class="kw">class</span>="nm">0</span>;</span>
<span class="line">        myCar.<span class="mt">accelerate</span>();</span>
<span class="line">        myCar.<span class="mt">accelerate</span>();</span>
<span class="line">    }</span>
<span class="line">}</span>
<span class="line"><span class="cm">// Output:</span></span>
<span class="line"><span class="cm">// Toyota is now going 10 km/h</span></span>
<span class="line"><span class="cm">// Toyota is now going 20 km/h</span></span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Example 1: Your first class and object')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Example 2: Constructor chaining with this()</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">public</span> <span class="kw">class</span> <span class="cl">Student</span> {</span>
<span class="line">    <span class="kw"><span class="cl">String</span></span> name;</span>
<span class="line">    <span class="kw">int</span> age;</span>
<span class="line">    <span class="kw"><span class="cl">String</span></span> course;</span>
<span class="line"></span>
<span class="line">    <span class="cl">Student</span>() {</span>
<span class="line">        <span class="kw">this</span>(<span <span class="kw">class</span>="st">"<span class="cl">Unknown</span>"</span>, <span <span class="kw">class</span>="nm">18</span>, <span <span class="kw">class</span>="st">"<span class="cl">General</span>"</span>);</span>
<span class="line">    }</span>
<span class="line"></span>
<span class="line">    <span class="cl">Student</span>(<span class="kw"><span class="cl">String</span></span> name, <span class="kw">int</span> age, <span class="kw"><span class="cl">String</span></span> course) {</span>
<span class="line">        <span class="kw">this</span>.name = name;</span>
<span class="line">        <span class="kw">this</span>.age = age;</span>
<span class="line">        <span class="kw">this</span>.course = course;</span>
<span class="line">    }</span>
<span class="line"></span>
<span class="line">    <span class="kw">public</span> <span class="kw">static</span> <span class="kw">void</span> <span class="mt">main</span>(<span class="kw"><span class="cl">String</span></span>[] args) {</span>
<span class="line">        <span class="cl">Student</span> s1 = <span class="kw">new</span> <span class="cl">Student</span>();</span>
<span class="line">        <span class="cl">Student</span> s2 = <span class="kw">new</span> <span class="cl">Student</span>(<span <span class="kw">class</span>="st">"<span class="cl">Alice</span>"</span>, <span <span class="kw">class</span>="nm">20</span>, <span <span class="kw">class</span>="st">"<span class="cl">CS</span>"</span>);</span>
<span class="line">        <span class="cl">System</span>.out.<span class="mt">println</span>(s1.name + <span <span class="kw">class</span>="st">" | "</span> + s1.course);</span>
<span class="line">        <span class="cl">System</span>.out.<span class="mt">println</span>(s2.name + <span <span class="kw">class</span>="st">" | "</span> + s2.course);</span>
<span class="line">    }</span>
<span class="line">}</span>
<span class="line"><span class="cm">// Output:</span></span>
<span class="line"><span class="cm">// Unknown | General</span></span>
<span class="line"><span class="cm">// Alice | CS</span></span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Example 2: Constructor chaining with this()')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="oop-summary-card">
                    <h3>Key Points - Intro to OOP</h3>
                    <ul>
                        <li>OOP prevents procedural "spaghetti code" via extreme modularity.</li>
                        <li>Classes operate as templates loaded logically; Objects are RAM occurrences.</li>
                        <li>The <code>new</code> keyword connects the Heap allocation strategy directly to Java
                            constructors.</li>
                    </ul>
                </div>
            </section>

            <section id="chapter-2" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 02</span>
                    <h2>Classes and Objects (Deep Dive)</h2>
                </div>
                <h3 class="oop-subheading">Static Fields vs Instance State</h3>
                <p class="oop-text">Understanding the dichotomy between static and instance boundaries defines the
                    lifecycle of JVM elements. Instance variables bind inherently to exact objects. Generating 10,000
                    distinct Employee instances commands 10,000 unique memory allocations for the 'employeeId' field.
                    Conversely, a Static variable ignores instance replication. Defining 'static String companyName'
                    forces exactly one memory pointer within the Metaspace. Updating the static field instantly
                    broadcasts the mutation globally across all instances since they all consult the singular Method
                    Area reference.</p>
                <p class="oop-text">The <code>this</code> keyword is Java's explicit architectural tie breaking tool. It
                    represents an indisputable pointer back to "myself"&mdash;the object currently executing inside an
                    implicit context. The 5 critical deployments involve: untangling parameter shadowing (where a
                    constructor argument mirrors an instance field name), forcing constructor chaining via `this()`,
                    passing the current object to external methods, returning the current context to support Fluent
                    Builder APIS, and qualifying fields against static interference.</p>
                <p class="oop-text">Java mandates automatic object lifecycle termination via Garbage Collection. When an
                    allocated object entirely loses all incoming Stack, Static, or JNI references, it descends into
                    unreachability. A daemon thread, acting as the JVM Reaper, executes the Mark-and-Sweep algorithm,
                    permanently purging unlinked objects. Understanding <code>toString()</code> and
                    <code>equals()</code> overrides controls how referencing functions, allowing architectural object
                    equality rather than simple heap address comparison.</p>

                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:#1e293b;padding:15px;border-radius:8px;"><code>public class Session {
    static int globalConnections = 0; // Metaspace
    int userId; // Heap per object

    public Session(int userId) {
        this.userId = userId; // Shadows resolution
        Session.globalConnections++; // Static mutation
    }
}
// Trace:
Session s1 = new Session(101); // global=1, userId=101
Session s2 = new Session(102); // global=2, userId=102
</code></pre>
                </div>

                <div class="oop-diagram-box">
                    <svg width="400" height="180" viewBox="0 0 400 180">
                        <circle cx="100" cy="90" r="60" fill="#fef3c7" stroke="#d97706" stroke-width="4" />
                        <text x="100" y="85" font-family="monospace" text-anchor="middle" fill="#b45309">Creation</text>
                        <text x="100" y="105" font-size="10" text-anchor="middle">new()</text>

                        <circle cx="200" cy="90" r="30" fill="#dcfce7" stroke="#15803d" stroke-width="4" />
                        <text x="200" y="95" font-family="monospace" font-size="12" text-anchor="middle"
                            fill="#166534">Active</text>

                        <circle cx="300" cy="90" r="60" fill="#fee2e2" stroke="#b91c1c" stroke-width="4" />
                        <text x="300" y="85" font-family="monospace" text-anchor="middle" fill="#991b1b">GC Sweep</text>
                        <text x="300" y="105" font-size="10" text-anchor="middle">Unreachable</text>

                        <line x1="165" y1="90" x2="165" y2="90" stroke="#000" />
                    </svg>
                </div>

                <br>
                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Static vs Instance Variables</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">public</span> <span class="kw">class</span> <span class="cl">Counter</span> {</span>
<span class="line">    <span class="kw">static</span> <span class="kw">int</span> globalCount = <span <span class="kw">class</span>="nm">0</span>;</span>
<span class="line">    <span class="kw">int</span> instanceCount = <span <span class="kw">class</span>="nm">0</span>;</span>
<span class="line"></span>
<span class="line">    <span class="cl">Counter</span>() {</span>
<span class="line">        globalCount++;</span>
<span class="line">        instanceCount++;</span>
<span class="line">    }</span>
<span class="line"></span>
<span class="line">    <span class="kw">public</span> <span class="kw">static</span> <span class="kw">void</span> <span class="mt">main</span>(<span class="kw"><span class="cl">String</span></span>[] args) {</span>
<span class="line">        <span class="cl">Counter</span> c1 = <span class="kw">new</span> <span class="cl">Counter</span>();</span>
<span class="line">        <span class="cl">Counter</span> c2 = <span class="kw">new</span> <span class="cl">Counter</span>();</span>
<span class="line">        <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Global</span>: "</span> + <span class="cl">Counter</span>.globalCount);</span>
<span class="line">        <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">C1</span> <span class="cl">Instance</span>: "</span> + c1.instanceCount);</span>
<span class="line">    }</span>
<span class="line">}</span>
<span class="line"><span class="cm">// Output:</span></span>
<span class="line"><span class="cm">// Global: 2</span></span>
<span class="line"><span class="cm">// C1 Instance: 1</span></span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Static vs Instance Variables')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">The 5 Uses of 'this'</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">public</span> <span class="kw">class</span> <span class="cl">ThisDemo</span> {</span>
<span class="line">    <span class="kw">int</span> id;</span>
<span class="line"></span>
<span class="line">    <span class="cl">ThisDemo</span>(<span class="kw">int</span> id) {</span>
<span class="line">        <span class="kw">this</span>.id = id; <span class="cm">// 1. Shadowing</span></span>
<span class="line">    }</span>
<span class="line">    </span>
<span class="line">    <span class="cl">ThisDemo</span>() {</span>
<span class="line">        <span class="kw">this</span>(<span <span class="kw">class</span>="nm">0</span>); <span class="cm">// 2. Constructor chain</span></span>
<span class="line">    }</span>
<span class="line"></span>
<span class="line">    <span class="kw">void</span> <span class="mt">passContext</span>() {</span>
<span class="line">        <span class="cl">Helper</span>.<span class="mt">process</span>(<span class="kw">this</span>); <span class="cm">// 3. Pass self</span></span>
<span class="line">    }</span>
<span class="line"></span>
<span class="line">    <span class="cl">ThisDemo</span> <span class="mt">getBuilder</span>() {</span>
<span class="line">        <span class="kw">return</span> <span class="kw">this</span>; <span class="cm">// 4. Return self</span></span>
<span class="line">    }</span>
<span class="line">    </span>
<span class="line">    <span class="kw">class</span> <span class="cl">Inner</span> {</span>
<span class="line">        <span class="kw">void</span> <span class="mt">accessOuter</span>() {</span>
<span class="line">            <span class="kw">int</span> x = <span class="cl">ThisDemo</span>.<span class="kw">this</span>.id; <span class="cm">// 5. Outer class qualifier</span></span>
<span class="line">        }</span>
<span class="line">    }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('The 5 Uses of \'this\'')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Overriding toString, equals, hashCode</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">import</span> java.util.<span class="cl">Objects</span>;</span>
<span class="line"><span class="kw">public</span> <span class="kw">class</span> <span class="cl">User</span> {</span>
<span class="line">    <span class="kw">int</span> id;</span>
<span class="line">    <span class="kw"><span class="cl">String</span></span> name;</span>
<span class="line"></span>
<span class="line">    <span class="cl">User</span>(<span class="kw">int</span> i, <span class="kw"><span class="cl">String</span></span> n) { id=i; name=n; }</span>
<span class="line"></span>
<span class="line">    <span <span class="kw">class</span>="an">@<span class="cl">Override</span></span></span>
<span class="line">    <span class="kw">public</span> <span class="kw">boolean</span> <span class="mt">equals</span>(<span class="cl">Object</span> o) {</span>
<span class="line">        <span class="kw">if</span> (<span class="kw">this</span> == o) <span class="kw">return</span> true;</span>
<span class="line">        <span class="kw">if</span> (o == null || <span class="mt">getClass</span>() != o.<span class="mt">getClass</span>()) <span class="kw">return</span> false;</span>
<span class="line">        <span class="cl">User</span> user = (<span class="cl">User</span>) o;</span>
<span class="line">        <span class="kw">return</span> id == user.id &amp;&amp; <span class="cl">Objects</span>.<span class="mt">equals</span>(name, user.name);</span>
<span class="line">    }</span>
<span class="line"></span>
<span class="line">    <span <span class="kw">class</span>="an">@<span class="cl">Override</span></span></span>
<span class="line">    <span class="kw">public</span> <span class="kw">int</span> <span class="mt">hashCode</span>() {</span>
<span class="line">        <span class="kw">return</span> <span class="cl">Objects</span>.<span class="mt">hash</span>(id, name);</span>
<span class="line">    }</span>
<span class="line">    </span>
<span class="line">    <span <span class="kw">class</span>="an">@<span class="cl">Override</span></span></span>
<span class="line">    <span class="kw">public</span> <span class="kw"><span class="cl">String</span></span> <span class="mt">toString</span>() {</span>
<span class="line">        <span class="kw">return</span> <span <span class="kw">class</span>="st">"<span class="cl">User</span>["</span> + id + <span <span class="kw">class</span>="st">" - "</span> + name + <span <span class="kw">class</span>="st">"]"</span>;</span>
<span class="line">    }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Overriding toString, equals, hashCode')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Copy Constructor</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">public</span> <span class="kw">class</span> <span class="cl">Config</span> {</span>
<span class="line">    <span class="kw"><span class="cl">String</span></span> theme;</span>
<span class="line">    <span class="kw">int</span> version;</span>
<span class="line"></span>
<span class="line">    <span class="cl">Config</span>(<span class="kw"><span class="cl">String</span></span> theme, <span class="kw">int</span> version) {</span>
<span class="line">        <span class="kw">this</span>.theme = theme;</span>
<span class="line">        <span class="kw">this</span>.version = version;</span>
<span class="line">    }</span>
<span class="line"></span>
<span class="line">    <span class="cm">// Copy Constructor</span></span>
<span class="line">    <span class="cl">Config</span>(<span class="cl">Config</span> source) {</span>
<span class="line">        <span class="kw">this</span>.theme = source.theme;</span>
<span class="line">        <span class="kw">this</span>.version = source.version;</span>
<span class="line">    }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Copy Constructor')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="oop-summary-card">
                    <h3>Key Points - Classes & Objects</h3>
                    <ul>
                        <li>Instance variables multiply with object count; Static variables are strictly singletons
                            globally.</li>
                        <li>Constructor overloading requires distinct signature signatures to permit chaining via
                            <code>this()</code>.</li>
                        <li>Overriding <code>equals()</code> vs <code>hashCode()</code> prevents lethal logic failures
                            in HashMaps.</li>
                    </ul>
                </div>
            </section>

            <section id="chapter-3" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 03</span>
                    <h2>Encapsulation</h2>
                </div>
                <h3 class="oop-subheading">Creating Data Shields</h3>
                <p class="oop-text">Encapsulation establishes the absolute boundary preventing state corruption. A class
                    without encapsulation represents an exposed nerve, allowing raw manipulation bypassing business
                    logic. If a BankAccount class leaves the <code>balance</code> field open, a rogue script can
                    trivially assign a negative value, entirely circumventing overdraft algorithms. By changing the
                    balance to <code>private</code> and filtering input via a <code>setBalance()</code> gateway, we
                    inject vital defensive programming boundaries.</p>
                <p class="oop-text">Java leverages four primary access modifiers: <code>private</code> (locked to the
                    current class), <code>default</code> or package-private (accessible to neighbor classes residing in
                    identical directory structures), <code>protected</code> (available to identical packages OR child
                    subclasses located anywhere globally), and <code>public</code> (total unhindered universal access).
                    An engineer defaults all internal state instantly to private, systematically uncovering them only
                    when an API consumer demands required operations.</p>
                <p class="oop-text">The encapsulation strategy extends into the universal JavaBean framework. A
                    recognized Java Bean explicitly combines a public zero-argument constructor, wholly private field
                    encapsulation, strictly named public getters/setters, and implements
                    <code>java.io.Serializable</code>. This explicit architecture guarantees compatibility across
                    massive enterprise frameworks ranging from Spring Boot DI configuration to Hibernate ORM mappings. A
                    dry run of un-encapsulated code often results in uncatchable IllegalStateExceptions crashing
                    production threads suddenly.</p>

                <div class="oop-diagram-box">
                    <svg width="450" height="160" viewBox="0 0 450 160">
                        <!-- Capsule visual -->
                        <path
                            d="M 100 80 Q 100 20 160 20 L 290 20 Q 350 20 350 80 Q 350 140 290 140 L 160 140 Q 100 140 100 80"
                            fill="#e0f2fe" stroke="#0284c7" stroke-width="3" />
                        <line x1="225" y1="20" x2="225" y2="140" stroke="#0284c7" stroke-width="3"
                            stroke-dasharray="6" />
                        <text x="160" y="85" font-weight="bold" font-family="monospace" fill="#0369a1">Data
                            (Private)</text>
                        <text x="290" y="85" font-weight="bold" font-family="monospace" fill="#0369a1">Methods
                            (Public)</text>
                        <!-- Hacker attempt -->
                        <path d="M 30 80 L 80 80" stroke="#dc2626" stroke-width="4" marker-end="url(#redArrow)" />
                        <text x="55" y="70" font-size="12" fill="#dc2626">Blocked Access</text>
                    </svg>
                </div>

                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:#1e293b;padding:15px;border-radius:8px;"><code>// Broken Model
class Player { public int health = 100; }
Player p = new Player();
p.health = -500; // Instantly breaks game logic. State ruined.

// Fixed Encapsulated Pattern
class ShieldedPlayer {
    private int health = 100;
    public void damage(int hit) {
        this.health = Math.max(0, this.health - hit); // Guard check
    }
}
</code></pre>
                </div>

                <br>
                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Full BankAccount Encapsulation</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">public</span> <span class="kw">class</span> <span class="cl">BankAccount</span> {</span>
<span class="line">    <span class="kw">private</span> <span class="kw">double</span> balance;</span>
<span class="line"></span>
<span class="line">    <span class="kw">public</span> <span class="cl">BankAccount</span>(<span class="kw">double</span> initialBalance) {</span>
<span class="line">        <span class="kw">if</span> (initialBalance &gt;= <span <span class="kw">class</span>="nm">0</span>) <span class="kw">this</span>.balance = initialBalance;</span>
<span class="line">    }</span>
<span class="line"></span>
<span class="line">    <span class="kw">public</span> <span class="kw">double</span> <span class="mt">getBalance</span>() {</span>
<span class="line">        <span class="kw">return</span> balance;</span>
<span class="line">    }</span>
<span class="line"></span>
<span class="line">    <span class="kw">public</span> <span class="kw">void</span> <span class="mt">deposit</span>(<span class="kw">double</span> amount) {</span>
<span class="line">        <span class="kw">if</span> (amount &gt; <span <span class="kw">class</span>="nm">0</span>) balance += amount;</span>
<span class="line">    }</span>
<span class="line"></span>
<span class="line">    <span class="kw">public</span> <span class="kw">void</span> <span class="mt">withdraw</span>(<span class="kw">double</span> amount) {</span>
<span class="line">        <span class="kw">if</span> (amount &gt; <span <span class="kw">class</span>="nm">0</span> &amp;&amp; balance &gt;= amount) balance -= amount;</span>
<span class="line">        <span class="kw">else</span> <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Invalid</span> withdrawal"</span>);</span>
<span class="line">    }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Full BankAccount Encapsulation')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Without Encapsulation vs Fixed</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="cm">// Bad (Exposed)</span></span>
<span class="line"><span class="kw">class</span> <span class="cl">BadAccount</span> {</span>
<span class="line">    <span class="kw">public</span> <span class="kw">double</span> balance;</span>
<span class="line">}</span>
<span class="line"></span>
<span class="line"><span class="cm">// Good (Defensive Validation)</span></span>
<span class="line"><span class="kw">class</span> <span class="cl">GoodAccount</span> {</span>
<span class="line">    <span class="kw">private</span> <span class="kw">double</span> balance;</span>
<span class="line">    <span class="kw">public</span> <span class="kw">void</span> <span class="mt">deposit</span>(<span class="kw">double</span> amt) { </span>
<span class="line">        <span class="kw">if</span>(amt&gt;<span <span class="kw">class</span>="nm">0</span>) balance+=amt; </span>
<span class="line">    }</span>
<span class="line">}</span>
<span class="line"><span class="cm">// BadAccount b = new BadAccount(); </span></span>
<span class="line"><span class="cm">// b.balance = -9000; // Exploit logic!</span></span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Without Encapsulation vs Fixed')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">JavaBean Specification</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">import</span> java.io.<span class="cl">Serializable</span>;</span>
<span class="line"></span>
<span class="line"><span class="kw">public</span> <span class="kw">class</span> <span class="cl">EmployeeBean</span> <span class="kw">implements</span> <span class="cl">Serializable</span> {</span>
<span class="line">    <span class="kw">private</span> <span class="kw">int</span> id;</span>
<span class="line">    <span class="kw">private</span> <span class="kw"><span class="cl">String</span></span> name;</span>
<span class="line"></span>
<span class="line">    <span class="cm">// Zero-arg public constructor</span></span>
<span class="line">    <span class="kw">public</span> <span class="cl">EmployeeBean</span>() {}</span>
<span class="line"></span>
<span class="line">    <span class="cm">// Getters and Setters</span></span>
<span class="line">    <span class="kw">public</span> <span class="kw">int</span> <span class="mt">getId</span>() { <span class="kw">return</span> id; }</span>
<span class="line">    <span class="kw">public</span> <span class="kw">void</span> <span class="mt">setId</span>(<span class="kw">int</span> id) { <span class="kw">this</span>.id = id; }</span>
<span class="line">    <span class="kw">public</span> <span class="kw"><span class="cl">String</span></span> <span class="mt">getName</span>() { <span class="kw">return</span> name; }</span>
<span class="line">    <span class="kw">public</span> <span class="kw">void</span> <span class="mt">setName</span>(<span class="kw"><span class="cl">String</span></span> name) { <span class="kw">this</span>.name = name; }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('JavaBean Specification')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="oop-summary-card">
                    <h3>Key Points - Encapsulation</h3>
                    <ul>
                        <li>Private fields prevent arbitrary, disastrous state corruption.</li>
                        <li>JavaBeans require encapsulation coupled with structural getters/setters systematically.</li>
                        <li>Protected modifier builds a bridge exclusively restricted to direct lineage or local
                            packages.</li>
                    </ul>
                </div>
            </section>

            <section id="chapter-4" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 04</span>
                    <h2>Inheritance</h2>
                </div>
                <h3 class="oop-subheading">Architectural Reusability and Inheritance Trees</h3>
                <p class="oop-text">Inheritance generates an unbreakable IS-A logical connection, propagating
                    pre-compiled behavioral logic vertically down class structures. Java strictly limits architectural
                    propagation to Single Class Inheritance. The catastrophic "Diamond Problem" of multiple inheritance
                    (where two parent interfaces define an identical colliding method) forces the JVM to block multiple
                    `extends` outright. To bypass this, Java pivots entirely to Multiple Interface Implementation.</p>
                <p class="oop-text">The <code>super</code> keyword bridges the inter-generational class divide. While
                    "this" accesses internal borders, "super" leaps into the Parent's scope. Constructing a child class
                    demands immediate invocation of the Parent architecture; thus, the JVM silently thrusts a
                    <code>super()</code> call into the first instruction line of a parameterized child constructor.
                    Variable shadowing frequently occurs during inheritance, whereby a child redeclares a parent's
                    variable. Utilizing <code>super.variableName</code> pierces the shadowed layer securely.</p>
                <p class="oop-text">The <code>final</code> modifier acts as an impervious lock on class extensions.
                    Deploying `final public class String` permanently shatters any attempt to extend String, acting as
                    an extreme architectural safeguard against malicious subclasses attempting to spoof crucial system
                    credentials. <code>instanceof</code> safely performs runtime validation logic on object lineage
                    before enabling forced downcasts, preventing the notorious ClassCastException.</p>

                <div class="oop-diagram-box">
                    <svg width="400" height="200" viewBox="0 0 400 200">
                        <rect x="150" y="10" width="100" height="40" fill="#fef08a" stroke="#a16207" stroke-width="2"
                            rx="5" />
                        <text x="200" y="35" font-family="monospace" text-anchor="middle"
                            font-weight="bold">Vehicle</text>
                        <path d="M 200 50 L 200 80" stroke="#000" stroke-width="2" />
                        <line x1="100" y1="80" x2="300" y2="80" stroke="#000" stroke-width="2" />
                        <path d="M 100 80 L 100 110" stroke="#000" stroke-width="2" marker-end="url(#arrowHead)" />
                        <path d="M 300 80 L 300 110" stroke="#000" stroke-width="2" marker-end="url(#arrowHead)" />

                        <rect x="50" y="110" width="100" height="40" fill="#bbf7d0" stroke="#15803d" stroke-width="2"
                            rx="5" />
                        <text x="100" y="135" font-family="monospace" text-anchor="middle">Car (IS-A)</text>

                        <rect x="250" y="110" width="100" height="40" fill="#bbf7d0" stroke="#15803d" stroke-width="2"
                            rx="5" />
                        <text x="300" y="135" font-family="monospace" text-anchor="middle">Truck (IS-A)</text>
                    </svg>
                </div>

                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:#1e293b;padding:15px;border-radius:8px;"><code>class Parent {
    public Parent() { System.out.println("[1] Parent Built"); }
}
class Child extends Parent {
    public Child() { 
        super(); // Implicitly inserted by compiler
        System.out.println("[2] Child Built"); 
    }
}
// Trace: new Child();
// Output: -> [1] Parent Built  -> [2] Child Built
</code></pre>
                </div>

                <br>
                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Multilevel Inheritance Chain</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">class</span> <span class="cl">Animal</span> {</span>
<span class="line">    <span class="kw">void</span> <span class="mt">eat</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Eating</span>..."</span>); }</span>
<span class="line">}</span>
<span class="line"><span class="kw">class</span> <span class="cl">Dog</span> <span class="kw">extends</span> <span class="cl">Animal</span> {</span>
<span class="line">    <span class="kw">void</span> <span class="mt">bark</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Barking</span>..."</span>); }</span>
<span class="line">}</span>
<span class="line"><span class="kw">class</span> <span class="cl">GoldenRetriever</span> <span class="kw">extends</span> <span class="cl">Dog</span> {</span>
<span class="line">    <span class="kw">void</span> <span class="mt">fetch</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Retrieving</span>..."</span>); }</span>
<span class="line">}</span>
<span class="line"><span class="cm">// GoldenRetriever g = new GoldenRetriever();</span></span>
<span class="line"><span class="cm">// g.eat(); g.bark(); g.fetch();</span></span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Multilevel Inheritance Chain')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">super Keyword (3 Uses)</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">class</span> <span class="cl">Parent</span> {</span>
<span class="line">    <span class="kw">int</span> value = <span <span class="kw">class</span>="nm">10</span>;</span>
<span class="line">    <span class="cl">Parent</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Parent</span> init"</span>); }</span>
<span class="line">    <span class="kw">void</span> <span class="mt">show</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Parent</span> <span class="cl">Show</span>"</span>); }</span>
<span class="line">}</span>
<span class="line"><span class="kw">class</span> <span class="cl">Child</span> <span class="kw">extends</span> <span class="cl">Parent</span> {</span>
<span class="line">    <span class="kw">int</span> value = <span <span class="kw">class</span>="nm">20</span>;</span>
<span class="line">    <span class="cl">Child</span>() {</span>
<span class="line">        <span class="kw">super</span>(); <span class="cm">// 1. Parent constructor</span></span>
<span class="line">    }</span>
<span class="line">    <span class="kw">void</span> <span class="mt">display</span>() {</span>
<span class="line">        <span class="kw">super</span>.<span class="mt">show</span>(); <span class="cm">// 2. Parent method</span></span>
<span class="line">        <span class="cl">System</span>.out.<span class="mt">println</span>(<span class="kw">super</span>.value); <span class="cm">// 3. Parent field</span></span>
<span class="line">    }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('super Keyword (3 Uses)')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Constructor Execution Trace</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">class</span> <span class="cl">A</span> { <span class="cl">A</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">A</span>"</span>); } }</span>
<span class="line"><span class="kw">class</span> <span class="cl">B</span> <span class="kw">extends</span> <span class="cl">A</span> { <span class="cl">B</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">B</span>"</span>); } }</span>
<span class="line"><span class="kw">class</span> <span class="cl">C</span> <span class="kw">extends</span> <span class="cl">B</span> { <span class="cl">C</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">C</span>"</span>); } }</span>
<span class="line"><span class="cm">// new C();</span></span>
<span class="line"><span class="cm">// Output: A, then B, then C</span></span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Constructor Execution Trace')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">instanceof and final</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">final</span> <span class="kw">class</span> <span class="cl">ImmutableCore</span> {} <span class="cm">// Cannot be subclassed</span></span>
<span class="line"></span>
<span class="line"><span class="kw">class</span> <span class="cl">App</span> {</span>
<span class="line">    <span class="kw">void</span> <span class="mt">check</span>(<span class="cl">Object</span> obj) {</span>
<span class="line">        <span class="kw">if</span> (obj instanceof <span class="kw"><span class="cl">String</span></span> str) {</span>
<span class="line">            <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">It</span>'s a string: "</span> + str.<span class="mt">toUpperCase</span>());</span>
<span class="line">        }</span>
<span class="line">    }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('instanceof and final')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="oop-summary-card">
                    <h3>Key Points - Inheritance</h3>
                    <ul>
                        <li>Child objects inherently load Parent states dynamically during heap memory mapping.</li>
                        <li>Method Hiding operates on static scopes, whereas Method Overriding dictates instance scopes.
                        </li>
                        <li>Java bans multi-class inheritance entirely to bypass compiler ambiguity cascades.</li>
                    </ul>
                </div>
            </section>

            <section id="chapter-5" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 05</span>
                    <h2>Polymorphism</h2>
                </div>
                <h3 class="oop-subheading">Dynamic Forms and VTables</h3>
                <p class="oop-text">Polymorphism separates into early bound Static Compile-time (Overloading) and
                    dangerously robust late bound Runtime (Overriding) execution paths. Method Overloading executes
                    simply: the compiler scans the parameter count, sequence, and data types, soldering the method call
                    to the precise signature securely prior to JVM startup. Return types never determine overloading
                    feasibility.</p>
                <p class="oop-text">Runtime Polymorphism represents the true pinnacle of Object-Oriented power. When a
                    Parent Class references a Child Object (Upcasting), an overriding method exists in duplicate. The
                    JVM utilizes Dynamic Method Dispatch: traversing the internal VTable mapping embedded within the
                    actual object chunk mapped inside heap memory. Regardless of the Parent pointer datatype, the JVM
                    dynamically dispatches command flows exclusively to the overriden Child execution code.</p>
                <p class="oop-text">Covariant return types represent a critical refinement extending late binding logic.
                    When an overriding child method executes, it explicitly permits modifying the base return type
                    strictly to a valid sub-class type. Upcasting operates invisibly without data manipulation risks.
                    Yet, accessing specific child capacities necessitates hazardous Downcasting. Forcing a cast blindly
                    commonly triggers fatal ClassCastExceptions, hence <code>instanceof</code> must tightly encircle and
                    insulate downcasting instructions safely.</p>

                <div class="oop-diagram-box">
                    <svg width="400" height="160" viewBox="0 0 400 160">
                        <rect x="50" y="20" width="300" height="50" fill="#f3e8ff" stroke="#7e22ce" stroke-width="2"
                            rx="8" />
                        <text x="200" y="50" font-family="monospace" text-anchor="middle"
                            font-weight="bold">List&lt;Object&gt; ref = new ArrayList&lt;&gt;();</text>
                        <!-- Paths -->
                        <path d="M 100 70 L 150 110" stroke="#7e22ce" stroke-width="2" marker-end="url(#arrow)" />
                        <text x="165" y="130" font-family="monospace" font-size="14">Execution targets ArrayList
                            specific logic.</text>
                        <text x="165" y="150" font-family="monospace" font-size="12" fill="#6b7280">(Resolved via
                            internal JVM VTable pointer)</text>
                    </svg>
                </div>

                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:#1e293b;padding:15px;border-radius:8px;"><code>class Bird { void fly() { System.out.println("Flap"); } }
class Eagle extends Bird { 
    @Override 
    void fly() { System.out.println("Soar aggressively"); } 
}

// Trace Execution Code
Bird b = new Eagle(); // Upcasting - Compiler allows
b.fly(); // Runtime VTable sees Eagle, Output: "Soar aggressively"
</code></pre>
                </div>

                <br>
                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Method Overloading</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">class</span> <span class="cl">Calculator</span> {</span>
<span class="line">    <span class="kw">int</span> <span class="mt">add</span>(<span class="kw">int</span> a, <span class="kw">int</span> b) { <span class="kw">return</span> a + b; }</span>
<span class="line">    <span class="kw">int</span> <span class="mt">add</span>(<span class="kw">int</span> a, <span class="kw">int</span> b, <span class="kw">int</span> c) { <span class="kw">return</span> a + b + c; }</span>
<span class="line">    <span class="kw">double</span> <span class="mt">add</span>(<span class="kw">double</span> a, <span class="kw">double</span> b) { <span class="kw">return</span> a + b; }</span>
<span class="line">    <span class="kw"><span class="cl">String</span></span> <span class="mt">add</span>(<span class="kw"><span class="cl">String</span></span> a, <span class="kw"><span class="cl">String</span></span> b) { <span class="kw">return</span> a + b; }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Method Overloading')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Method Overriding</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">class</span> <span class="cl">Bird</span> {</span>
<span class="line">    <span class="kw">void</span> <span class="mt">move</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Flying</span>"</span>); }</span>
<span class="line">}</span>
<span class="line"><span class="kw">class</span> <span class="cl">Penguin</span> <span class="kw">extends</span> <span class="cl">Bird</span> {</span>
<span class="line">    <span <span class="kw">class</span>="an">@<span class="cl">Override</span></span></span>
<span class="line">    <span class="kw">void</span> <span class="mt">move</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Swimming</span>"</span>); }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Method Overriding')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Dynamic Dispatch</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">class</span> <span class="cl">Shape</span> { <span class="kw">void</span> <span class="mt">draw</span>() {} }</span>
<span class="line"><span class="kw">class</span> <span class="cl">Circle</span> <span class="kw">extends</span> <span class="cl">Shape</span> { <span class="kw">void</span> <span class="mt">draw</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"o"</span>); } }</span>
<span class="line"><span class="kw">class</span> <span class="cl">Rectangle</span> <span class="kw">extends</span> <span class="cl">Shape</span> { <span class="kw">void</span> <span class="mt">draw</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"[]"</span>); } }</span>
<span class="line"></span>
<span class="line"><span class="cm">// Runtime morphs the reference</span></span>
<span class="line"><span class="cl">Shape</span> s1 = <span class="kw">new</span> <span class="cl">Circle</span>();</span>
<span class="line"><span class="cl">Shape</span> s2 = <span class="kw">new</span> <span class="cl">Rectangle</span>();</span>
<span class="line">s1.<span class="mt">draw</span>(); <span class="cm">// o</span></span>
<span class="line">s2.<span class="mt">draw</span>(); <span class="cm">// []</span></span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Dynamic Dispatch')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Upcasting and Downcasting</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre
                        class="code-block-body"><code><span class="line"><span class="cl">Animal</span> a = <span class="kw">new</span> <span class="cl">Dog</span>(); <span class="cm">// Upcast (Safe)</span></span>
<span class="line">a.<span class="mt">eat</span>(); <span class="cm">// Valid</span></span>
<span class="line"></span>
<span class="line"><span class="kw">if</span> (a instanceof <span class="cl">Dog</span>) {</span>
<span class="line">    <span class="cl">Dog</span> d = (<span class="cl">Dog</span>) a; <span class="cm">// Downcast</span></span>
<span class="line">    d.<span class="mt">bark</span>();</span>
<span class="line">}</span>
<span class="line"></span>
<span class="line"><span class="kw">try</span> {</span>
<span class="line">    <span class="cl">Cat</span> c = (<span class="cl">Cat</span>) a; <span class="cm">// ClassCastException</span></span>
<span class="line">} <span class="kw">catch</span> (<span class="cl">ClassCastException</span> e) {}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Upcasting and Downcasting')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="oop-summary-card">
                    <h3>Key Points - Polymorphism</h3>
                    <ul>
                        <li>Static Overloading uses argument permutations to bind logic at compilation securely.</li>
                        <li>Dynamic Dispatch leverages VTables to redirect calls to overriding subclass layers.</li>
                        <li>Downcasting generates severe ClassCastException risk absent 'instanceof' perimeter checks.
                        </li>
                    </ul>
                </div>
            </section>

            <section id="chapter-6" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 06</span>
                    <h2>Abstraction</h2>
                </div>
                <h3 class="oop-subheading">Eliminating Internal Method Complexity</h3>
                <p class="oop-text">Abstraction deliberately conceals the gritty backend framework, surfacing
                    exclusively the public API interface. Real world scenario: steering a vehicle. You command the
                    steering wheel heavily without requiring absolute mechanical knowledge of the power steering fluid
                    hydraulics. In Java, <code>abstract</code> classes form a hybrid structure linking fully functional
                    method implementations with vacuous abstract declarations demanding subclass resolutions.</p>
                <p class="oop-text">Architects frequently construct base abstract classes locking common state variables
                    while projecting partial behavior logic requirements. You absolutely cannot instantiate an abstract
                    class using the <code>new</code> command. Abstract constructors logically map memory hierarchies for
                    inheritance sequences, nonetheless, object generation outright aborts. When a child class adopts an
                    abstract parent, compiler severity mandates strict overriding of every abstract parameter, else the
                    child class similarly faces abstraction condemnation.</p>
                <p class="oop-text">Interfaces deliver extreme "pure" abstraction blueprints devoid of any instance
                    state logic. While an abstract class specifies "what an object is" fundamentally, interfaces specify
                    strictly "what an object behaves like". Interfaces define aggressive capability contracts. Marking
                    classes via Marker Interfaces (Serializable, Cloneable, Remote) executes specialized internal JVM
                    hooks mapping bytecode instruction loops exclusively triggered via marker presence.</p>

                <div class="oop-diagram-box">
                    <svg width="450" height="180" viewBox="0 0 450 180">
                        <polygon points="225,10 100,50 350,50" fill="#e0e7ff" stroke="#4338ca" stroke-width="2" />
                        <text x="225" y="35" font-size="12" font-family="monospace" text-anchor="middle">Abstract
                            Hierarchy</text>

                        <rect x="80" y="80" width="130" height="60" fill="#fee2e2" stroke="#b91c1c" stroke-width="2"
                            rx="5" />
                        <text x="145" y="110" font-family="monospace" font-size="12" text-anchor="middle">abstract
                            Base()</text>
                        <text x="145" y="125" font-size="10" text-anchor="middle" fill="#ef4444">CANNOT
                            <code>new()</code></text>

                        <path d="M 145 140 L 145 160" stroke="#b91c1c" stroke-width="2" />
                        <line x1="145" y1="160" x2="345" y2="160" stroke="#b91c1c" stroke-width="2" />
                        <path d="M 345 160 L 345 140" stroke="#b91c1c" stroke-width="2" />

                        <rect x="280" y="80" width="130" height="60" fill="#dcfce7" stroke="#15803d" stroke-width="2"
                            rx="5" />
                        <text x="345" y="110" font-family="monospace" font-size="12"
                            text-anchor="middle">ConcreteChild()</text>
                        <text x="345" y="125" font-size="10" text-anchor="middle" fill="#22c55e">Safe allocation</text>
                    </svg>
                </div>

                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:#1e293b;padding:15px;border-radius:8px;"><code>abstract class APIClient {
    public void connect() { System.out.println("TCP Linked."); }
    abstract void processPayload(); // Enforced contract
}
class WebClient extends APIClient {
    @Override
    void processPayload() { System.out.println("Parsing JSON."); }
}
// Trace:
APIClient current = new WebClient();
current.connect();
current.processPayload(); // Safely executes overridden code.
</code></pre>
                </div>

                <br>
                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Abstract Classes</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">abstract</span> <span class="kw">class</span> <span class="cl">Shape</span> {</span>
<span class="line">    <span class="kw">abstract</span> <span class="kw">double</span> <span class="mt">area</span>();</span>
<span class="line">    <span class="kw">void</span> <span class="mt">log</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Calculating</span> area..."</span>); }</span>
<span class="line">}</span>
<span class="line"><span class="kw">class</span> <span class="cl">Circle</span> <span class="kw">extends</span> <span class="cl">Shape</span> {</span>
<span class="line">    <span class="kw">double</span> r;</span>
<span class="line">    <span class="cl">Circle</span>(<span class="kw">double</span> r) { <span class="kw">this</span>.r = r; }</span>
<span class="line">    <span class="kw">double</span> <span class="mt">area</span>() { <span class="kw">return</span> <span <span class="kw">class</span>="nm">3</span>.<span <span class="kw">class</span>="nm">14</span> * r * r; }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Abstract Classes')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Interface Features (Java 8+)</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">interface</span> <span class="cl">ModernAPI</span> {</span>
<span class="line">    <span class="kw">void</span> <span class="mt">required</span>(); <span class="cm">// Abstract</span></span>
<span class="line">    </span>
<span class="line">    <span class="kw">default</span> <span class="kw">void</span> <span class="mt">fallback</span>() {</span>
<span class="line">        <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Default</span> backup behavior"</span>);</span>
<span class="line">    }</span>
<span class="line">    </span>
<span class="line">    <span class="kw">static</span> <span class="kw">void</span> <span class="mt">setup</span>() {</span>
<span class="line">        <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Static</span> factory"</span>);</span>
<span class="line">    }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Interface Features (Java 8+)')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Multiple Implementation</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">interface</span> <span class="cl">Printable</span> { <span class="kw">void</span> <span class="mt">print</span>(); }</span>
<span class="line"><span class="kw">interface</span> <span class="cl">Savable</span> { <span class="kw">void</span> <span class="mt">save</span>(); }</span>
<span class="line"></span>
<span class="line"><span class="kw">class</span> <span class="cl">Document</span> <span class="kw">implements</span> <span class="cl">Printable</span>, <span class="cl">Savable</span> {</span>
<span class="line">    <span class="kw">public</span> <span class="kw">void</span> <span class="mt">print</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Printing</span>"</span>); }</span>
<span class="line">    <span class="kw">public</span> <span class="kw">void</span> <span class="mt">save</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Saving</span>"</span>); }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Multiple Implementation')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Functional Interface & Lambda</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre
                        class="code-block-body"><code><span class="line"><span <span class="kw">class</span>="an">@<span class="cl">FunctionalInterface</span></span></span>
<span class="line"><span class="kw">interface</span> <span class="cl">MathOp</span> {</span>
<span class="line">    <span class="kw">int</span> <span class="mt">execute</span>(<span class="kw">int</span> a, <span class="kw">int</span> b);</span>
<span class="line">}</span>
<span class="line"></span>
<span class="line"><span class="cm">// Lambda usage</span></span>
<span class="line"><span class="cl">MathOp</span> add = (a, b) -&gt; a + b;</span>
<span class="line"><span class="kw">int</span> res = add.<span class="mt">execute</span>(<span <span class="kw">class</span>="nm">5</span>, <span <span class="kw">class</span>="nm">10</span>); <span class="cm">// 15</span></span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Functional Interface & Lambda')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="oop-summary-card">
                    <h3>Key Points - Abstraction</h3>
                    <ul>
                        <li>Abstract classes blend state data architectures with unfulfilled method constraints
                            simultaneously.</li>
                        <li>Interfaces operate as capability models defining extreme contractual programming.</li>
                        <li>Marker interfaces harbor zero executable code, operating purely to alert JVM subsystem
                            hooks.</li>
                    </ul>
                </div>
            </section>

            <section id="chapter-7" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 07</span>
                    <h2>Interfaces (Deep Dive & Modernization)</h2>
                </div>
                <h3 class="oop-subheading">From Java 7 to 17 Architectural Evolutions</h3>
                <p class="oop-text">The fundamental interface construct dictates that all declared variables implicitly
                    possess <code>public static final</code> immutability, acting functionally as global constants.
                    Pre-Java 8 implementations demanded interfaces exist as 100% pure abstractions&mdash;no method possessed a
                    body. Java 8 radically broke tradition by introducing <code>default</code> methods into interfaces
                    natively. Default architectures enable backward compatibility universally across enormous library
                    frameworks. Adding newly required methods avoids breaking thousands of pre-existing implementing
                    classes globally by injecting functional fallback logic locally within the interface scope.</p>
                <p class="oop-text">Java 8 also embedded static interface mappings allowing utility computations locally
                    housed within the interface barrier. Subsequently, Java 9 enhanced structural density by initiating
                    <code>private</code> interface methods. Private architectures permit isolating complex duplication
                    routines shared exclusively by various internal default capabilities mapped inside the interface,
                    fortifying encapsulation integrity natively inside the abstract framework.</p>
                <p class="oop-text">Interfaces actively interact within modern functional landscapes heavily. Functional
                    Interfaces (containing strictly one abstract method via <code>@FunctionalInterface</code>
                    annotation) fundamentally integrate into Lambda Calculus mechanisms propelling the vast Java Streams
                    API. Modern architectures view interfaces not just as structural rigid contracts but as intensely
                    dynamic functional lambda pointers targeting specific bytecode algorithms directly.</p>

                <div class="oop-diagram-box">
                    <svg width="450" height="120" viewBox="0 0 450 120">
                        <circle cx="80" cy="60" r="30" fill="#f1f5f9" stroke="#94a3b8" stroke-width="3" />
                        <text x="80" y="65" font-size="14" font-weight="bold">J7</text>
                        <path d="M 110 60 L 190 60" stroke="#94a3b8" stroke-width="2" marker-end="url(#arrow)" />

                        <circle cx="220" cy="60" r="35" fill="#e0f2fe" stroke="#0284c7" stroke-width="3" />
                        <text x="220" y="55" font-size="14" font-weight="bold">J8</text>
                        <text x="220" y="70" font-size="10" fill="#0284c7">Default</text>
                        <path d="M 255 60 L 335 60" stroke="#0284c7" stroke-width="2" marker-end="url(#arrow)" />

                        <circle cx="370" cy="60" r="40" fill="#dbeafe" stroke="#1d4ed8" stroke-width="3" />
                        <text x="370" y="50" font-size="14" font-weight="bold">J9+</text>
                        <text x="370" y="65" font-size="10" fill="#1d4ed8">Private</text>
                        <text x="370" y="80" font-size="10" fill="#1d4ed8">Methods</text>
                    </svg>
                </div>

                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:#1e293b;padding:15px;border-radius:8px;"><code>public interface PaymentProcessor {
    void process(double amt); // Abstract pure
    
    // Java 8 Backward-Compatible Hook
    default void logTransaction(double amt) {
        System.out.println("Default Interface Payload: $" + format(amt));
    }
    
    // Java 9 Private encapsulation shielding duplication logic
    private String format(double data) { return Math.abs(data)+""; }
}
</code></pre>
                </div>

                <br>
                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Payment Strategy Interface</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">interface</span> <span class="cl">PaymentProcessor</span> {</span>
<span class="line">    <span class="kw">void</span> <span class="mt">pay</span>(<span class="kw">double</span> amount);</span>
<span class="line">}</span>
<span class="line"><span class="kw">class</span> <span class="cl">CreditCard</span> <span class="kw">implements</span> <span class="cl">PaymentProcessor</span> {</span>
<span class="line">    <span class="kw">public</span> <span class="kw">void</span> <span class="mt">pay</span>(<span class="kw">double</span> a) { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Card</span>: $"</span> + a); }</span>
<span class="line">}</span>
<span class="line"><span class="kw">class</span> <span class="cl">UPI</span> <span class="kw">implements</span> <span class="cl">PaymentProcessor</span> {</span>
<span class="line">    <span class="kw">public</span> <span class="kw">void</span> <span class="mt">pay</span>(<span class="kw">double</span> a) { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">UPI</span>: $"</span> + a); }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Payment Strategy Interface')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Default Method Conflicts</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">interface</span> <span class="cl">A</span> { <span class="kw">default</span> <span class="kw">void</span> <span class="mt">show</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">A</span>"</span>); } }</span>
<span class="line"><span class="kw">interface</span> <span class="cl">B</span> { <span class="kw">default</span> <span class="kw">void</span> <span class="mt">show</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">B</span>"</span>); } }</span>
<span class="line"></span>
<span class="line"><span class="kw">class</span> <span class="cl">C</span> <span class="kw">implements</span> <span class="cl">A</span>, <span class="cl">B</span> {</span>
<span class="line">    <span class="kw">public</span> <span class="kw">void</span> <span class="mt">show</span>() {</span>
<span class="line">        <span class="cl">A</span>.<span class="kw">super</span>.<span class="mt">show</span>(); <span class="cm">// Resolves ambiguity</span></span>
<span class="line">    }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Default Method Conflicts')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Marker Interface</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">import</span> java.io.<span class="cl">Serializable</span>;</span>
<span class="line"></span>
<span class="line"><span class="cm">// Serializable has no methods, it marks metadata</span></span>
<span class="line"><span class="kw">class</span> <span class="cl">Config</span> <span class="kw">implements</span> <span class="cl">Serializable</span> {</span>
<span class="line">    <span class="kw"><span class="cl">String</span></span> url;</span>
<span class="line">    <span class="cl">Config</span>(<span class="kw"><span class="cl">String</span></span> u) { url = u; }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Marker Interface')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="oop-summary-card">
                    <h3>Key Points - Interface Evolution</h3>
                    <ul>
                        <li>Private interface components abstract shared procedural computations heavily.</li>
                        <li>Default implementations bypass destructive refactoring cycles targeting legacy libraries.
                        </li>
                        <li>Functional Interfaces bind directly to modern Lambda expression logic structures.</li>
                    </ul>
                </div>
            </section>

            <section id="chapter-8" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 08</span>
                    <h2>Advanced OOP Concepts</h2>
                </div>
                <h3 class="oop-subheading">Enums, Generics, and Nested Topologies</h3>
                <p class="oop-text">Inner class frameworks project behavioral proximity limits tightly encircling scope
                    accessibility. A non-static inner class directly links to an explicit instance of the dominating
                    outer class natively. Anonymous Inner classes act as single-use architecture blocks. In UI listeners
                    or multithreaded logic configurations, they condense repetitive template generation code
                    drastically, spawning custom instances overriding methods mid-flight without declaring a permanent
                    new file extension globally.</p>
                <p class="oop-text">Advanced enumeration paradigms fundamentally reshape typing configuration
                    capabilities radically. A Java <code>enum</code> transcends procedural C-style constants utterly.
                    Enums operate internally as heavily fortified, sealed Java classes. Each enum property physically
                    represents an explicit, thread-safe Singleton Object generated concurrently at JVM startup sequence
                    initialization. Enums legally enclose fields, constructor configurations, and polymorphic override
                    logic exclusively securely.</p>
                <p class="oop-text">Generics apply universal type-safety shielding dynamically mapped elements strictly
                    at compiling limits. They intercept severe runtime data pollution faults forcefully avoiding
                    continuous dangerous implicit casting logic executions automatically. Object class core frameworks
                    define JVM operational boundaries. Techniques like cloning natively require marker interactions
                    shielding shallow vs deep architecture duplication mapping directly referencing operating system
                    memory block arrays intrinsically utilizing <code>clone()</code> logic.</p>

                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:#1e293b;padding:15px;border-radius:8px;"><code>enum ServerStatus {
    ACTIVE(200), DOWN(500); // Thread-safe singleton creation calls
    
    private int httpCode; // Encapsulated property
    ServerStatus(int code) { this.httpCode = code; } // Implicitly Private logic
    public int getCode() { return httpCode; }
}
// Trace Code: 
System.out.println(ServerStatus.ACTIVE.getCode()); // Output: 200
</code></pre>
                </div>

                <br>
                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Static Nested Class</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">class</span> <span class="cl">Helper</span> {</span>
<span class="line">    <span class="kw">static</span> <span class="kw">class</span> <span class="cl">MathUtils</span> {</span>
<span class="line">        <span class="kw">static</span> <span class="kw">int</span> <span class="mt">max</span>(<span class="kw">int</span> a, <span class="kw">int</span> b) { <span class="kw">return</span> a&gt;b?a:b; }</span>
<span class="line">    }</span>
<span class="line">}</span>
<span class="line"><span class="cm">// Usage: Helper.MathUtils.max(5, 10);</span></span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Static Nested Class')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Inner (Member) Class</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">class</span> <span class="cl">Box</span> {</span>
<span class="line">    <span class="kw">private</span> <span class="kw"><span class="cl">String</span></span> id = <span <span class="kw">class</span>="st">"<span class="cl">BOX12</span>"</span>;</span>
<span class="line">    <span class="kw">class</span> <span class="cl">Content</span> {</span>
<span class="line">        <span class="kw">void</span> <span class="mt">reveal</span>() { <span class="cl">System</span>.out.<span class="mt">println</span>(id); }</span>
<span class="line">    }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Inner (Member) Class')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Anonymous Class</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre
                        class="code-block-body"><code><span class="line"><span class="cl">Runnable</span> r = <span class="kw">new</span> <span class="cl">Runnable</span>() {</span>
<span class="line">    <span <span class="kw">class</span>="an">@<span class="cl">Override</span></span></span>
<span class="line">    <span class="kw">public</span> <span class="kw">void</span> <span class="mt">run</span>() {</span>
<span class="line">        <span class="cl">System</span>.out.<span class="mt">println</span>(<span <span class="kw">class</span>="st">"<span class="cl">Running</span> inline thread"</span>);</span>
<span class="line">    }</span>
<span class="line">};</span>
<span class="line"><span class="kw">new</span> <span class="cl">Thread</span>(r).<span class="mt">start</span>();</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Anonymous Class')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Enum with State</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">enum</span> <span class="cl">Level</span> {</span>
<span class="line">    <span class="cl">LOW</span>(<span <span class="kw">class</span>="nm">1</span>), <span class="cl">MEDIUM</span>(<span <span class="kw">class</span>="nm">5</span>), <span class="cl">HIGH</span>(<span <span class="kw">class</span>="nm">10</span>);</span>
<span class="line">    </span>
<span class="line">    <span class="kw">private</span> <span class="kw">int</span> severity;</span>
<span class="line">    <span class="cl">Level</span>(<span class="kw">int</span> s) { severity = s; }</span>
<span class="line">    <span class="kw">public</span> <span class="kw">int</span> <span class="mt">getSeverity</span>() { <span class="kw">return</span> severity; }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Enum with State')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Generics Pair<T, U></span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre
                        class="code-block-body"><code><span class="line"><span class="kw">class</span> <span class="cl">Pair</span>&lt;<span class="cl">T</span>, <span class="cl">U</span>&gt; {</span>
<span class="line">    <span class="cl">T</span> first;</span>
<span class="line">    <span class="cl">U</span> second;</span>
<span class="line">    <span class="cl">Pair</span>(<span class="cl">T</span> f, <span class="cl">U</span> s) { first = f; second = s; }</span>
<span class="line">}</span>
<span class="line"><span class="cm">// Pair&lt;String, Integer&gt; p = new Pair&lt;&gt;("Age", 30);</span></span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Generics Pair<T, U>')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="oop-summary-card">
                    <h3>Key Points - Advanced Operations</h3>
                    <ul>
                        <li>Generics obliterate raw data parsing casting bugs violently during compiler pass operations
                            natively.</li>
                        <li>Anonymous classes replace lengthy boilerplate configurations seamlessly reducing massive
                            code blobs.</li>
                        <li>Enums functionally embed robust architectural singletons implicitly enforcing thread-safe
                            runtime data scopes logically.</li>
                    </ul>
                </div>
            </section>

            <section id="chapter-9" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 09</span>
                    <h2>OOP Design Principles (SOLID)</h2>
                </div>
                <h3 class="oop-subheading">Enterprise Architecture Foundations</h3>
                <p class="oop-text">The SOLID principles establish the foundational engineering code requirements
                    preventing enterprise projects from collapsing into fragile monolith structures randomly over
                    lifecycle spans. <strong>S - Single Responsibility Principle:</strong> A class should execute
                    strictly one designated purpose. An Employee class handles employee operations, it absolutely should
                    never contain JDBC database connection logic simultaneously inherently.</p>
                <p class="oop-text"><strong>O - Open/Closed Principle:</strong> Core components demand accessibility
                    enabling system expansion logically, yet absolutely restrict structural modification directly. If
                    implementing new discount policies demands editing core logic sequences fundamentally, the
                    architecture violates Open/Closed principles severely. <strong>L - Liskov Substitution
                        Principle:</strong> An application must seamlessly digest child objects natively wherever parent
                    structures operate. An Ostrich class extending Bird breaks Liskov mapping functionally if it
                    structurally throws an exception when the required `fly()` algorithm executes.</p>
                <p class="oop-text"><strong>I - Interface Segregation Principle:</strong> Enforcing massive monolithic
                    interface structures generates "Fat" interfaces crippling system logic. Clients must never be
                    compelled automatically to override abstract logic irrelevant entirely. Refactor fat constraints
                    iteratively into sharp specific contracts. <strong>D - Dependency Inversion Principle:</strong>
                    System logic targets abstractions fundamentally natively, ignoring concrete class structures.
                    Injecting interface configurations dynamically isolates core modules radically eliminating
                    destructive tight logic coupling randomly.</p>

                <div class="oop-diagram-box">
                    <svg width="450" height="180" viewBox="0 0 450 180">
                        <polygon points="50,90 100,50 150,90 100,130" fill="#fef08a" stroke="#a16207"
                            stroke-width="2" />
                        <text x="100" y="95" font-size="24" font-weight="bold" text-anchor="middle">S</text>

                        <polygon points="120,90 170,50 220,90 170,130" fill="#bbf7d0" stroke="#15803d"
                            stroke-width="2" />
                        <text x="170" y="95" font-size="24" font-weight="bold" text-anchor="middle">O</text>

                        <polygon points="190,90 240,50 290,90 240,130" fill="#bfdbfe" stroke="#1d4ed8"
                            stroke-width="2" />
                        <text x="240" y="95" font-size="24" font-weight="bold" text-anchor="middle">L</text>

                        <polygon points="260,90 310,50 360,90 310,130" fill="#e9d5ff" stroke="#7e22ce"
                            stroke-width="2" />
                        <text x="310" y="95" font-size="24" font-weight="bold" text-anchor="middle">I</text>

                        <polygon points="330,90 380,50 430,90 380,130" fill="#fecdd3" stroke="#be123c"
                            stroke-width="2" />
                        <text x="380" y="95" font-size="24" font-weight="bold" text-anchor="middle">D</text>

                        <text x="240" y="160" font-size="14" font-family="monospace" text-anchor="middle"
                            fill="#475569">Robust Enterprise Architectural Stability</text>
                    </svg>
                </div>

                <br>
                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Single Responsibility Principle (SRP)</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre
                        class="code-block-body"><code><span class="line"><span class="cm">// Bad: Mixed logic</span></span>
<span class="line"><span class="kw">class</span> <span class="cl">UserStore</span> {</span>
<span class="line">    <span class="kw">void</span> <span class="mt">save</span>(<span class="cl">User</span> u) { /* <span class="cl">DB</span> logic */ }</span>
<span class="line">    <span class="kw">void</span> <span class="mt">email</span>(<span class="cl">User</span> u) { /* <span class="cl">SMTP</span> logic */ }</span>
<span class="line">}</span>
<span class="line"></span>
<span class="line"><span class="cm">// Good: Separated</span></span>
<span class="line"><span class="kw">class</span> <span class="cl">UserRepository</span> { <span class="kw">void</span> <span class="mt">save</span>(<span class="cl">User</span> u) {} }</span>
<span class="line"><span class="kw">class</span> <span class="cl">EmailService</span> { <span class="kw">void</span> <span class="mt">email</span>(<span class="cl">User</span> u) {} }</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Single Responsibility Principle (SRP)')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Open/Closed Principle</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">interface</span> <span class="cl">Shape</span> { <span class="kw">double</span> <span class="mt">area</span>(); }</span>
<span class="line"><span class="kw">class</span> <span class="cl">Circle</span> <span class="kw">implements</span> <span class="cl">Shape</span> { </span>
<span class="line">    <span class="kw">double</span> r; </span>
<span class="line">    <span class="kw">public</span> <span class="kw">double</span> <span class="mt">area</span>() { <span class="kw">return</span> <span <span class="kw">class</span>="nm">3</span>.<span <span class="kw">class</span>="nm">14</span>*r*r; } </span>
<span class="line">}</span>
<span class="line"><span class="kw">class</span> <span class="cl">AreaCalculator</span> {</span>
<span class="line">    <span class="kw">double</span> <span class="mt">total</span>(<span class="cl">Shape</span>[] shapes) {</span>
<span class="line">        <span class="kw">double</span> sum = <span <span class="kw">class</span>="nm">0</span>;</span>
<span class="line">        <span class="kw">for</span>(<span class="cl">Shape</span> s : shapes) sum += s.<span class="mt">area</span>();</span>
<span class="line">        <span class="kw">return</span> sum;</span>
<span class="line">    }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Open/Closed Principle')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Liskov Substitution Principle</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre
                        class="code-block-body"><code><span class="line"><span class="cm">// Violation</span></span>
<span class="line"><span class="kw">class</span> <span class="cl">Bird</span> { <span class="kw">void</span> <span class="mt">fly</span>() {} }</span>
<span class="line"><span class="kw">class</span> <span class="cl">Ostrich</span> <span class="kw">extends</span> <span class="cl">Bird</span> { </span>
<span class="line">    <span class="kw">void</span> <span class="mt">fly</span>() { <span class="kw">throw</span> <span class="kw">new</span> <span class="cl">RuntimeException</span>(<span <span class="kw">class</span>="st">"<span class="cl">Cannot</span> fly"</span>); } </span>
<span class="line">}</span>
<span class="line"></span>
<span class="line"><span class="cm">// Fix</span></span>
<span class="line"><span class="kw">class</span> <span class="cl">Bird</span> {}</span>
<span class="line"><span class="kw">class</span> <span class="cl">FlyingBird</span> <span class="kw">extends</span> <span class="cl">Bird</span> { <span class="kw">void</span> <span class="mt">fly</span>() {} }</span>
<span class="line"><span class="kw">class</span> <span class="cl">Ostrich</span> <span class="kw">extends</span> <span class="cl">Bird</span> {}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Liskov Substitution Principle')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Interface Segregation Principle</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="cm">// Fat Interface (Bad)</span></span>
<span class="line"><span class="kw">interface</span> <span class="cl">Worker</span> { <span class="kw">void</span> <span class="mt">work</span>(); <span class="kw">void</span> <span class="mt">eat</span>(); }</span>
<span class="line"></span>
<span class="line"><span class="cm">// Split (Good)</span></span>
<span class="line"><span class="kw">interface</span> <span class="cl">Workable</span> { <span class="kw">void</span> <span class="mt">work</span>(); }</span>
<span class="line"><span class="kw">interface</span> <span class="cl">Eatable</span> { <span class="kw">void</span> <span class="mt">eat</span>(); }</span>
<span class="line"><span class="kw">class</span> <span class="cl">Robot</span> <span class="kw">implements</span> <span class="cl">Workable</span> {</span>
<span class="line">    <span class="kw">public</span> <span class="kw">void</span> <span class="mt">work</span>() {}</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Interface Segregation Principle')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Dependency Inversion Principle</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">interface</span> <span class="cl">DB</span> { <span class="kw">void</span> <span class="mt">connect</span>(); }</span>
<span class="line"><span class="kw">class</span> <span class="cl">MySQL</span> <span class="kw">implements</span> <span class="cl">DB</span> { <span class="kw">public</span> <span class="kw">void</span> <span class="mt">connect</span>() {} }</span>
<span class="line"></span>
<span class="line"><span class="cm">// High level depends on interface, not concretion</span></span>
<span class="line"><span class="kw">class</span> <span class="cl">App</span> {</span>
<span class="line">    <span class="cl">DB</span> database;</span>
<span class="line">    <span class="cl">App</span>(<span class="cl">DB</span> db) { <span class="kw">this</span>.database = db; }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Dependency Inversion Principle')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="oop-summary-card">
                    <h3>Key Points - SOLID</h3>
                    <ul>
                        <li>Violating Single Responsibility creates god-classes heavily burdened with tight dependencies
                            globally.</li>
                        <li>Liskov dictates subclasses operate transparently without corrupting superclass architectural
                            contracts securely.</li>
                        <li>Dependency Inversion removes hard-coded instances injecting conceptual interface logic
                            securely.</li>
                    </ul>
                </div>
            </section>

            <section id="chapter-10" class="oop-chapter">
                <div class="oop-chapter-header">
                    <span class="chapter-num">Chapter 10</span>
                    <h2>OOP Design Patterns</h2>
                </div>
                <h3 class="oop-subheading">Creational, Structural, and Behavioral Architectures</h3>
                <p class="oop-text">Design pattern blueprints outline generalized robust logic schemas fixing recurring
                    programming constraints natively universally. Creational templates isolate object creation
                    configurations cleanly cleanly. The Singleton restricts a class globally permitting exactly one
                    single instantiation. Eager Singletons create instances instantly upon class loading. Lazy
                    Singletons drastically preserve memory, mapping configuration merely during initial procedural logic
                    calls. Implementing Double-Checked Locking synchronizes instantiation sequences blocking malicious
                    multithread race conditions safely.</p>
                <p class="oop-text">The Factory mapping pattern executes conditional object instantiation schemas
                    shielding logic rules internally. Rather than injecting messy if-else initialization randomly
                    throughout code algorithms, passing an index string explicitly enables the Factory to map object
                    allocations properly outputting specialized abstracted structures functionally securely. The Builder
                    schema dominates configuration structures requiring heavily customized multiple optional variable
                    assignments, generating code seamlessly tracking fluid configurations linearly sequentially.</p>
                <p class="oop-text">Behavioral frameworks dominate internal message communication schemas drastically
                    securely. The Observer configures decoupled publish-subscribe algorithms globally. Iterators shield
                    underlying collection arrays logically uniformly sequentially traversing arrays dynamically without
                    revealing foundational memory mappings inherently natively securely. Following modern architectural
                    templates secures complex systems heavily.</p>

                <div class="oop-dry-run">
                    <pre style="margin:0;color:#e2e8f0;background:#1e293b;padding:15px;border-radius:8px;"><code>public class DatabaseConnection {
    private static volatile DatabaseConnection instance; // Thread-visibility config
    
    // Double-Checked Locking Singleton Logic
    public static DatabaseConnection getInstance() {
        if(instance == null) {
            synchronized(DatabaseConnection.class) {
                if(instance == null) instance = new DatabaseConnection();
            }
        }
        return instance; 
    }
}
</code></pre>
                </div>

                <br>
                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Singleton (Double-Checked Locking)</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">public</span> <span class="kw">class</span> <span class="cl">Database</span> {</span>
<span class="line">    <span class="kw">private</span> <span class="kw">static</span> volatile <span class="cl">Database</span> instance;</span>
<span class="line">    <span class="kw">private</span> <span class="cl">Database</span>() {}</span>
<span class="line">    </span>
<span class="line">    <span class="kw">public</span> <span class="kw">static</span> <span class="cl">Database</span> <span class="mt">getInstance</span>() {</span>
<span class="line">        <span class="kw">if</span>(instance == null) {</span>
<span class="line">            <span class="mt">synchronized</span>(<span class="cl">Database</span>.<span class="kw">class</span>) {</span>
<span class="line">                <span class="kw">if</span>(instance == null) instance = <span class="kw">new</span> <span class="cl">Database</span>();</span>
<span class="line">            }</span>
<span class="line">        }</span>
<span class="line">        <span class="kw">return</span> instance;</span>
<span class="line">    }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Singleton (Double-Checked Locking)')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Factory Pattern</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">class</span> <span class="cl">DocumentFactory</span> {</span>
<span class="line">    <span class="kw">static</span> <span class="cl">Document</span> <span class="mt">create</span>(<span class="kw"><span class="cl">String</span></span> type) {</span>
<span class="line">        <span class="kw">if</span>(type.<span class="mt">equals</span>(<span <span class="kw">class</span>="st">"<span class="cl">PDF</span>"</span>)) <span class="kw">return</span> <span class="kw">new</span> <span class="cl">PDFDoc</span>();</span>
<span class="line">        <span class="kw">if</span>(type.<span class="mt">equals</span>(<span <span class="kw">class</span>="st">"<span class="cl">Word</span>"</span>)) <span class="kw">return</span> <span class="kw">new</span> <span class="cl">WordDoc</span>();</span>
<span class="line">        <span class="kw">throw</span> <span class="kw">new</span> <span class="cl">IllegalArgumentException</span>();</span>
<span class="line">    }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Factory Pattern')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Builder Pattern</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">class</span> <span class="cl">Pizza</span> {</span>
<span class="line">    <span class="kw">boolean</span> cheese, pepperoni;</span>
<span class="line">    <span class="kw">private</span> <span class="cl">Pizza</span>(<span class="cl">Builder</span> b) {</span>
<span class="line">        <span class="kw">this</span>.cheese = b.cheese;</span>
<span class="line">        <span class="kw">this</span>.pepperoni = b.pepperoni;</span>
<span class="line">    }</span>
<span class="line">    </span>
<span class="line">    <span class="kw">static</span> <span class="kw">class</span> <span class="cl">Builder</span> {</span>
<span class="line">        <span class="kw">boolean</span> cheese, pepperoni;</span>
<span class="line">        <span class="cl">Builder</span> <span class="mt">addCheese</span>() { cheese = true; <span class="kw">return</span> <span class="kw">this</span>; }</span>
<span class="line">        <span class="cl">Builder</span> <span class="mt">addPepperoni</span>() { pepperoni = true; <span class="kw">return</span> <span class="kw">this</span>; }</span>
<span class="line">        <span class="cl">Pizza</span> <span class="mt">build</span>() { <span class="kw">return</span> <span class="kw">new</span> <span class="cl">Pizza</span>(<span class="kw">this</span>); }</span>
<span class="line">    }</span>
<span class="line">}</span>
<span class="line"><span class="cm">// Pizza p = new Pizza.Builder().addCheese().build();</span></span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Builder Pattern')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="code-block-wrapper">
                    <div class="code-block-header">
                        <div class="code-block-dots">
                            <span class="dot dot-red"></span>
                            <span class="dot dot-yellow"></span>
                            <span class="dot dot-green"></span>
                        </div>
                        <span class="code-block-title">Observer Pattern</span>
                        <button class="copy-btn" onclick="copyCode(this)">Copy</button>
                    </div>
                    <pre class="code-block-body"><code><span class="line"><span class="kw">import</span> java.util.*;</span>
<span class="line"><span class="kw">interface</span> <span class="cl">Listener</span> { <span class="kw">void</span> <span class="mt">update</span>(<span class="kw"><span class="cl">String</span></span> evt); }</span>
<span class="line"></span>
<span class="line"><span class="kw">class</span> <span class="cl">EventManager</span> {</span>
<span class="line">    <span class="cl">List</span>&lt;<span class="cl">Listener</span>&gt; subs = <span class="kw">new</span> <span class="cl">ArrayList</span>&lt;&gt;();</span>
<span class="line">    <span class="kw">void</span> <span class="mt">subscribe</span>(<span class="cl">Listener</span> l) { subs.<span class="mt">add</span>(l); }</span>
<span class="line">    <span class="kw">void</span> <span class="mt">notifyAll</span>(<span class="kw"><span class="cl">String</span></span> e) {</span>
<span class="line">        <span class="kw">for</span>(<span class="cl">Listener</span> l : subs) l.<span class="mt">update</span>(e);</span>
<span class="line">    }</span>
<span class="line">}</span></code></pre>
                    <button class="try-it-btn" onclick="tryExample('Observer Pattern')">
                        🧪 Quiz me on this &rarr;
                    </button>
                </div>

                <div class="oop-summary-card">
                    <h3>Key Points - Design Patterns</h3>
                    <ul>
                        <li>Singleton architectures block destructive global variable duplications drastically via
                            memory locks securely.</li>
                        <li>Factories centralize object mapping rules significantly isolating external system logic
                            natively accurately.</li>
                        <li>Behavioral templates govern logic interaction arrays dynamically securely globally
                            effectively.</li>
                    </ul>
                </div>
            </section>


            <script>
                function copyCode(btn) {
                    const pre = btn.closest('.code-block-wrapper').querySelector('pre');
                    const text = pre.innerText;
                    navigator.clipboard.writeText(text).then(() => {
                        btn.textContent = 'Copied!';
                        btn.classList.add('copied');
                        setTimeout(() => {
                            btn.textContent = 'Copy';
                            btn.classList.remove('copied');
                        }, 2000);
                    });
                }
                function tryExample(topicName) {
                    window.location.href = 'QuizServlet?category=oop';
                }
            </script>

        </main>
    </div>

    <script>
        // Chapter nav spy
        const sections = document.querySelectorAll('section[id]');
        const navLinks = document.querySelectorAll('.chapter-nav-link');
        const progressBar = document.getElementById('readingProgressBar');

        window.addEventListener('scroll', () => {
            let current = '';
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                if (pageYOffset >= sectionTop - 150) {
                    current = section.getAttribute('id');
                }
            });

            navLinks.forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('data-target') === current) {
                    link.classList.add('active');
                }
            });

            // Reading progress calculation
            const winScroll = document.body.scrollTop || document.documentElement.scrollTop;
            const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
            const scrolled = (winScroll / height) * 100;
            if (progressBar && height > 0) {
                progressBar.style.width = scrolled + "%";
            }
        });

        // Checkbox LocalStorage integration
        const checkboxes = document.querySelectorAll('.chapter-checkbox');
        checkboxes.forEach(chk => {
            let id = chk.id;
            if (localStorage.getItem(id) === 'true') {
                chk.checked = true;
            }
            chk.addEventListener('change', function () {
                localStorage.setItem(id, this.checked);
            });
        });

        function searchNotes() {
            let val = prompt("Enter search term:");
            if (val && val.trim() !== "") {
                window.find(val);
            }
        }
    </script>
</div>

<a href="QuizServlet?category=oop" class="take-quiz-btn">
    Ready? Take the OOP Concepts Quiz &rarr;
</a>

<script src="js/theme.js"></script>
</body>
</html>