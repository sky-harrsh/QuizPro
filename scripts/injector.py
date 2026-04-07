import re
import os

html_template = """
<div class="code-block-wrapper">
  <div class="code-block-header">
    <div class="code-block-dots">
      <span class="dot dot-red"></span>
      <span class="dot dot-yellow"></span>
      <span class="dot dot-green"></span>
    </div>
    <span class="code-block-title">{title}</span>
    <button class="copy-btn" onclick="copyCode(this)">Copy</button>
  </div>
  <pre class="code-block-body"><code>{code}</code></pre>
  <button class="try-it-btn" onclick="tryExample('{title_esc}')">
      🧪 Quiz me on this →
  </button>
</div>
"""

def highlight_java(code_str):
    lines = code_str.strip().split('\n')
    highlighted_lines = []
    
    kws = r'\b(public|class|void|static|return|import|extends|interface|new|throws|String|int|boolean|private|protected|super|this|final|abstract|implements|default|enum|double|float|long|boolean|byte|short|char|if|else|for|while|switch|case|break|continue|try|catch|finally|throw|package)\b'
    
    for org_line in lines:
        line = org_line.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
        
        # Strings "..."
        # But wait, doing regex naively might conflict. A simpler approach is just doing it sequentially avoiding overlaps if possible.
        # It's better to just highlight keywords first outside of strings.
        # We will use simple heuristics.
        
        # Comments //...
        comment_match = re.search(r'//.*$', line)
        comment_part = ""
        if comment_match:
            comment_part = comment_match.group(0)
            line = line[:comment_match.start()]
            
        # Strings "..."
        line = re.sub(r'("[^"]*")', r'<span class="st">\1</span>', line)
        
        # Annotations @...
        line = re.sub(r'(@[A-Za-z0-9_]+)', r'<span class="an">\1</span>', line)
        
        # Numbers 0-9
        line = re.sub(r'\b(\d+)\b', r'<span class="nm">\1</span>', line)
        
        # Keywords
        line = re.sub(kws, r'<span class="kw">\1</span>', line)
        
        # Class names (Capitalized words not inside spans)
        # simplistic: word starting with upper case.
        line = re.sub(r'\b([A-Z][a-zA-Z0-9_]*)\b', r'<span class="cl">\1</span>', line)
        
        # Method calls
        line = re.sub(r'\b([a-z][a-zA-Z0-9_]*)\s*\(', r'<span class="mt">\1</span>(', line)
        
        if comment_part:
            line += f'<span class="cm">{comment_part}</span>'
            
        highlighted_lines.append(f'<span class="line">{line}</span>')
        
    return '\n'.join(highlighted_lines)

snippets = {
    1: [
        ("Example 1: Your first class and object", """public class Car {
    String brand;
    int speed;

    void accelerate() {
        speed += 10;
        System.out.println(brand + " is now going " + speed + " km/h");
    }

    public static void main(String[] args) {
        Car myCar = new Car();
        myCar.brand = "Toyota";
        myCar.speed = 0;
        myCar.accelerate();
        myCar.accelerate();
    }
}
// Output:
// Toyota is now going 10 km/h
// Toyota is now going 20 km/h"""),
        ("Example 2: Constructor chaining with this()", """public class Student {
    String name;
    int age;
    String course;

    Student() {
        this("Unknown", 18, "General");
    }

    Student(String name, int age, String course) {
        this.name = name;
        this.age = age;
        this.course = course;
    }

    public static void main(String[] args) {
        Student s1 = new Student();
        Student s2 = new Student("Alice", 20, "CS");
        System.out.println(s1.name + " | " + s1.course);
        System.out.println(s2.name + " | " + s2.course);
    }
}
// Output:
// Unknown | General
// Alice | CS""")
    ],
    2: [
        ("Static vs Instance Variables", """public class Counter {
    static int globalCount = 0;
    int instanceCount = 0;

    Counter() {
        globalCount++;
        instanceCount++;
    }

    public static void main(String[] args) {
        Counter c1 = new Counter();
        Counter c2 = new Counter();
        System.out.println("Global: " + Counter.globalCount);
        System.out.println("C1 Instance: " + c1.instanceCount);
    }
}
// Output:
// Global: 2
// C1 Instance: 1"""),
        ("The 5 Uses of 'this'", """public class ThisDemo {
    int id;

    ThisDemo(int id) {
        this.id = id; // 1. Shadowing
    }
    
    ThisDemo() {
        this(0); // 2. Constructor chain
    }

    void passContext() {
        Helper.process(this); // 3. Pass self
    }

    ThisDemo getBuilder() {
        return this; // 4. Return self
    }
    
    class Inner {
        void accessOuter() {
            int x = ThisDemo.this.id; // 5. Outer class qualifier
        }
    }
}"""),
        ("Overriding toString, equals, hashCode", """import java.util.Objects;
public class User {
    int id;
    String name;

    User(int i, String n) { id=i; name=n; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return id == user.id && Objects.equals(name, user.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, name);
    }
    
    @Override
    public String toString() {
        return "User[" + id + " - " + name + "]";
    }
}"""),
        ("Copy Constructor", """public class Config {
    String theme;
    int version;

    Config(String theme, int version) {
        this.theme = theme;
        this.version = version;
    }

    // Copy Constructor
    Config(Config source) {
        this.theme = source.theme;
        this.version = source.version;
    }
}""")
    ],
    3: [
        ("Full BankAccount Encapsulation", """public class BankAccount {
    private double balance;

    public BankAccount(double initialBalance) {
        if (initialBalance >= 0) this.balance = initialBalance;
    }

    public double getBalance() {
        return balance;
    }

    public void deposit(double amount) {
        if (amount > 0) balance += amount;
    }

    public void withdraw(double amount) {
        if (amount > 0 && balance >= amount) balance -= amount;
        else System.out.println("Invalid withdrawal");
    }
}"""),
        ("Without Encapsulation vs Fixed", """// Bad (Exposed)
class BadAccount {
    public double balance;
}

// Good (Defensive Validation)
class GoodAccount {
    private double balance;
    public void deposit(double amt) { 
        if(amt>0) balance+=amt; 
    }
}
// BadAccount b = new BadAccount(); 
// b.balance = -9000; // Exploit logic!"""),
        ("JavaBean Specification", """import java.io.Serializable;

public class EmployeeBean implements Serializable {
    private int id;
    private String name;

    // Zero-arg public constructor
    public EmployeeBean() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
}""")
    ],
    4: [
        ("Multilevel Inheritance Chain", """class Animal {
    void eat() { System.out.println("Eating..."); }
}
class Dog extends Animal {
    void bark() { System.out.println("Barking..."); }
}
class GoldenRetriever extends Dog {
    void fetch() { System.out.println("Retrieving..."); }
}
// GoldenRetriever g = new GoldenRetriever();
// g.eat(); g.bark(); g.fetch();"""),
        ("super Keyword (3 Uses)", """class Parent {
    int value = 10;
    Parent() { System.out.println("Parent init"); }
    void show() { System.out.println("Parent Show"); }
}
class Child extends Parent {
    int value = 20;
    Child() {
        super(); // 1. Parent constructor
    }
    void display() {
        super.show(); // 2. Parent method
        System.out.println(super.value); // 3. Parent field
    }
}"""),
        ("Constructor Execution Trace", """class A { A() { System.out.println("A"); } }
class B extends A { B() { System.out.println("B"); } }
class C extends B { C() { System.out.println("C"); } }
// new C();
// Output: A, then B, then C"""),
        ("instanceof and final", """final class ImmutableCore {} // Cannot be subclassed

class App {
    void check(Object obj) {
        if (obj instanceof String str) {
            System.out.println("It's a string: " + str.toUpperCase());
        }
    }
}""")
    ],
    5: [
        ("Method Overloading", """class Calculator {
    int add(int a, int b) { return a + b; }
    int add(int a, int b, int c) { return a + b + c; }
    double add(double a, double b) { return a + b; }
    String add(String a, String b) { return a + b; }
}"""),
        ("Method Overriding", """class Bird {
    void move() { System.out.println("Flying"); }
}
class Penguin extends Bird {
    @Override
    void move() { System.out.println("Swimming"); }
}"""),
        ("Dynamic Dispatch", """class Shape { void draw() {} }
class Circle extends Shape { void draw() { System.out.println("o"); } }
class Rectangle extends Shape { void draw() { System.out.println("[]"); } }

// Runtime morphs the reference
Shape s1 = new Circle();
Shape s2 = new Rectangle();
s1.draw(); // o
s2.draw(); // []"""),
        ("Upcasting and Downcasting", """Animal a = new Dog(); // Upcast (Safe)
a.eat(); // Valid

if (a instanceof Dog) {
    Dog d = (Dog) a; // Downcast
    d.bark();
}

try {
    Cat c = (Cat) a; // ClassCastException
} catch (ClassCastException e) {}""")
    ],
    6: [
        ("Abstract Classes", """abstract class Shape {
    abstract double area();
    void log() { System.out.println("Calculating area..."); }
}
class Circle extends Shape {
    double r;
    Circle(double r) { this.r = r; }
    double area() { return 3.14 * r * r; }
}"""),
        ("Interface Features (Java 8+)", """interface ModernAPI {
    void required(); // Abstract
    
    default void fallback() {
        System.out.println("Default backup behavior");
    }
    
    static void setup() {
        System.out.println("Static factory");
    }
}"""),
        ("Multiple Implementation", """interface Printable { void print(); }
interface Savable { void save(); }

class Document implements Printable, Savable {
    public void print() { System.out.println("Printing"); }
    public void save() { System.out.println("Saving"); }
}"""),
        ("Functional Interface & Lambda", """@FunctionalInterface
interface MathOp {
    int execute(int a, int b);
}

// Lambda usage
MathOp add = (a, b) -> a + b;
int res = add.execute(5, 10); // 15""")
    ],
    7: [
        ("Payment Strategy Interface", """interface PaymentProcessor {
    void pay(double amount);
}
class CreditCard implements PaymentProcessor {
    public void pay(double a) { System.out.println("Card: $" + a); }
}
class UPI implements PaymentProcessor {
    public void pay(double a) { System.out.println("UPI: $" + a); }
}"""),
        ("Default Method Conflicts", """interface A { default void show() { System.out.println("A"); } }
interface B { default void show() { System.out.println("B"); } }

class C implements A, B {
    public void show() {
        A.super.show(); // Resolves ambiguity
    }
}"""),
        ("Marker Interface", """import java.io.Serializable;

// Serializable has no methods, it marks metadata
class Config implements Serializable {
    String url;
    Config(String u) { url = u; }
}""")
    ],
    8: [
        ("Static Nested Class", """class Helper {
    static class MathUtils {
        static int max(int a, int b) { return a>b?a:b; }
    }
}
// Usage: Helper.MathUtils.max(5, 10);"""),
        ("Inner (Member) Class", """class Box {
    private String id = "BOX12";
    class Content {
        void reveal() { System.out.println(id); }
    }
}"""),
        ("Anonymous Class", """Runnable r = new Runnable() {
    @Override
    public void run() {
        System.out.println("Running inline thread");
    }
};
new Thread(r).start();"""),
        ("Enum with State", """enum Level {
    LOW(1), MEDIUM(5), HIGH(10);
    
    private int severity;
    Level(int s) { severity = s; }
    public int getSeverity() { return severity; }
}"""),
        ("Generics Pair<T, U>", """class Pair<T, U> {
    T first;
    U second;
    Pair(T f, U s) { first = f; second = s; }
}
// Pair<String, Integer> p = new Pair<>("Age", 30);""")
    ],
    9: [
        ("Single Responsibility Principle (SRP)", """// Bad: Mixed logic
class UserStore {
    void save(User u) { /* DB logic */ }
    void email(User u) { /* SMTP logic */ }
}

// Good: Separated
class UserRepository { void save(User u) {} }
class EmailService { void email(User u) {} }"""),
        ("Open/Closed Principle", """interface Shape { double area(); }
class Circle implements Shape { 
    double r; 
    public double area() { return 3.14*r*r; } 
}
class AreaCalculator {
    double total(Shape[] shapes) {
        double sum = 0;
        for(Shape s : shapes) sum += s.area();
        return sum;
    }
}"""),
        ("Liskov Substitution Principle", """// Violation
class Bird { void fly() {} }
class Ostrich extends Bird { 
    void fly() { throw new RuntimeException("Cannot fly"); } 
}

// Fix
class Bird {}
class FlyingBird extends Bird { void fly() {} }
class Ostrich extends Bird {}"""),
        ("Interface Segregation Principle", """// Fat Interface (Bad)
interface Worker { void work(); void eat(); }

// Split (Good)
interface Workable { void work(); }
interface Eatable { void eat(); }
class Robot implements Workable {
    public void work() {}
}"""),
        ("Dependency Inversion Principle", """interface DB { void connect(); }
class MySQL implements DB { public void connect() {} }

// High level depends on interface, not concretion
class App {
    DB database;
    App(DB db) { this.database = db; }
}""")
    ],
    10: [
        ("Singleton (Double-Checked Locking)", """public class Database {
    private static volatile Database instance;
    private Database() {}
    
    public static Database getInstance() {
        if(instance == null) {
            synchronized(Database.class) {
                if(instance == null) instance = new Database();
            }
        }
        return instance;
    }
}"""),
        ("Factory Pattern", """class DocumentFactory {
    static Document create(String type) {
        if(type.equals("PDF")) return new PDFDoc();
        if(type.equals("Word")) return new WordDoc();
        throw new IllegalArgumentException();
    }
}"""),
        ("Builder Pattern", """class Pizza {
    boolean cheese, pepperoni;
    private Pizza(Builder b) {
        this.cheese = b.cheese;
        this.pepperoni = b.pepperoni;
    }
    
    static class Builder {
        boolean cheese, pepperoni;
        Builder addCheese() { cheese = true; return this; }
        Builder addPepperoni() { pepperoni = true; return this; }
        Pizza build() { return new Pizza(this); }
    }
}
// Pizza p = new Pizza.Builder().addCheese().build();"""),
        ("Observer Pattern", """import java.util.*;
interface Listener { void update(String evt); }

class EventManager {
    List<Listener> subs = new ArrayList<>();
    void subscribe(Listener l) { subs.add(l); }
    void notifyAll(String e) {
        for(Listener l : subs) l.update(e);
    }
}""")
    ]
}

def build_chapter_html(chapter_id):
    html = ""
    for title, code in snippets.get(chapter_id, []):
        hl_code = highlight_java(code)
        block = html_template.format(
            title=title, 
            title_esc=title.replace("'", "\\'"),
            code=hl_code
        )
        html += block
    return html

# Read oop-notes.jsp
target_file = r"c:\Users\Lenovo\OneDrive\Desktop\OnlineQuizSystem\WebContent\oop-notes.jsp"
with open(target_file, 'r', encoding='utf-8') as f:
    content = f.read()

# For each chapter block, we want to inject right before <div class="oop-summary-card">
for ch_num in range(1, 11):
    html_to_inject = build_chapter_html(ch_num)
    
    # We find the section for this chapter.
    # Pattern: <section id="chapter-{num}" ...> ... <div class="oop-summary-card">
    chapter_start = content.find(f'id="chapter-{ch_num}"')
    if chapter_start == -1:
        continue
        
    summary_card_idx = content.find('<div class="oop-summary-card">', chapter_start)
    if summary_card_idx != -1:
        # Check if we already injected to avoid duplicates
        if f'>{snippets[ch_num][0][0]}</span>' in content[chapter_start:summary_card_idx]:
            continue
            
        content = content[:summary_card_idx] + "<br>" + html_to_inject + "\n                " + content[summary_card_idx:]

# Adding script at the end
script_to_add = """
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
"""
if "function copyCode" not in content:
    content = content.replace("</main>", script_to_add + "\n        </main>")

with open(target_file, 'w', encoding='utf-8') as f:
    f.write(content)

print("Insertion completed successfully.")
