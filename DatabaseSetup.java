import java.sql.*;

public class DatabaseSetup {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/quizdb?useSSL=false&allowPublicKeyRetrieval=true";
        try (Connection c = DriverManager.getConnection(url, "root", "176023");
                Statement s = c.createStatement()) {

            try {
                s.execute("ALTER TABLE users ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP");
            } catch (Exception e) {
            }
            try {
                s.execute("ALTER TABLE results ADD COLUMN total_questions INT DEFAULT 15");
            } catch (Exception e) {
            }
            try {
                s.execute("ALTER TABLE results ADD COLUMN category VARCHAR(50) DEFAULT 'general'");
            } catch (Exception e) {
            }

            String sql = "INSERT INTO questions (category, question, option1, option2, option3, option4, correct_answer) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = c.prepareStatement(sql);

            String[][] qs = {
                    { "core",
                            "What is the output of this code?\n<pre><code>int x = 5;\nSystem.out.println(x++ + ++x);</code></pre>",
                            "10", "12", "11", "13", "12" },
                    { "core",
                            "What is the output?\n<pre><code>String s = \"Java\";\ns.concat(\" SE\");\nSystem.out.println(s);</code></pre>",
                            "Java SE", "Java", "Null", "Compilation Error", "Java" },
                    { "core", "What happens here?\n<pre><code>System.out.println(10 / 0.0);</code></pre>",
                            "ArithmeticException", "Infinity", "0.0", "Compilation Error", "Infinity" },
                    { "oop", "What is the output?\n<pre><code>class A { void m() { System.out.print(\"A\"); } }\nclass B extends A { void m() { System.out.print(\"B\"); } }\nA obj = new B(); obj.m();</code></pre>",
                            "A", "B", "AB", "Error", "B" },
                    { "oop", "Is this valid?\n<pre><code>interface I { default void show() {} }</code></pre>",
                            "No, interfaces cannot have method bodies", "Yes, since Java 8", "Only if I is abstract",
                            "Yes, since Java 11", "Yes, since Java 8" },
                    { "oop", "What happens?\n<pre><code>record Point(int x, int y) {}</code></pre>",
                            "Creates an immutable data class", "Error, record is not keyword",
                            "Creates a mutable class", "Generates only getters", "Creates an immutable data class" },
                    { "advanced",
                            "What is printed?\n<pre><code>Optional<String> opt = Optional.ofNullable(null);\nSystem.out.println(opt.orElse(\"Empty\"));</code></pre>",
                            "null", "Empty", "NullPointerException", "Exception", "Empty" },
                    { "advanced",
                            "What is returned?\n<pre><code>Stream.of(1, 2, 3).reduce(0, (a, b) -> a + b);</code></pre>",
                            "0", "6", "Error", "Returns a Stream", "6" },
                    { "advanced", "Is this valid?\n<pre><code>var list = new ArrayList<String>();</code></pre>",
                            "Yes, local var inference", "No, var must be strict", "Only in Java 8", "Error",
                            "Yes, local var inference" },
                    { "misc", "In Git, what does this do?\n<pre><code>git commit -am \"Fix\"</code></pre>",
                            "Adds and commits tracked files", "Commits all untracked files", "Creates an amend commit",
                            "Fails without git add", "Adds and commits tracked files" },
                    { "misc",
                            "What is the SQL output?\n<pre><code>SELECT count(*) FROM users WHERE age = NULL;</code></pre>",
                            "Syntax error", "Returns count of nulls", "Always 0", "Returns true", "Always 0" },
                    { "misc",
                            "What does this pattern signify?\n<pre><code>public static final Instance i = new Instance();</code></pre>",
                            "Factory", "Singleton", "Builder", "Observer", "Singleton" }
            };

            for (String[] q : qs) {
                for (int i = 0; i < 7; i++)
                    ps.setString(i + 1, q[i]);
                ps.executeUpdate();
            }
            System.out.println("Questions safely deployed!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
