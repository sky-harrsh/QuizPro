# QuizPro – Advanced Java Learning & Quiz Arena

**QuizPro** is a modern, high-performance Java web application designed to help engineering students and professionals master Java through interactive quizzes and comprehensive study materials.

---

## 🚀 Key Features

- **Dynamic Quiz Engine**: A React-powered, state-aware interface with real-time feedback and navigation palette.
- **Categorized Learning**: Distinct tracks for **Core Java**, **Object-Oriented Programming (OOP)**, **Advanced Java**, and **Miscellaneous** topics.
- **AI-Powered Questions**: Integrated Antropic API to generate fresh, relevant questions on-the-fly.
- **Engineering-Level Notes**: Detailed vertical-scroll study guides with SVG diagrams, code snippets, and progress tracking.
- **Unified Branding**: A sleek, modern UI with a dynamic Dark/Light mode and glassmorphism design elements.
- **Performance Results**: Instant scoring with "badge" grading and detailed answer explanation links.

---

## 🛠️ Tech Stack

- **Backend**: Java Servlets (Java EE), JDBC
- **Frontend**: JSP (JavaServer Pages), Tailwind CSS v3, React 18, FontAwesome 6
- **Database**: MySQL 8.0+
- **APIs**: Anthropic Claude API (for AI question generation)

---

## ⚙️ Setup Instructions

### 1. Database Configuration
1.  Ensure MySQL is running on `localhost:3306`.
2.  Import the schema:
    ```sh
    mysql -u root -p < sql/01_create_schema_and_seed.sql
    ```
3.  Verify connection settings in `src/db/DBConnection.java`.

### 2. Dependencies
Place the following JAR files in `WebContent/WEB-INF/lib`:
- `mysql-connector-java.jar` (MySQL JDBC Driver)
- `servlet-api.jar` (Provided by your server, e.g., Tomcat/lib)

### 3. AI Features (Optional)
To enable AI-powered question generation:
1.  Obtain an API key from Claude (Anthropic).
2.  Add it to `WebContent/WEB-INF/config.properties`.

---

## 📂 Project Structure

```text
OnlineQuizSystem/
├── src/
│   ├── db/DBConnection.java
│   ├── LoginServlet.java
│   ├── LogoutServlet.java
│   ├── QuizServlet.java
│   ├── ResultServlet.java
│   ├── NotesServlet.java
│   └── ProfileServlet.java
├── WebContent/
│   ├── WEB-INF/
│   ├── css/
│   ├── js/
│   ├── dashboard.jsp
│   ├── quiz.jsp
│   ├── result.jsp
│   ├── login.jsp
│   ├── notes-core.jsp
│   ├── notes-oop.jsp
│   ├── notes-advanced.jsp
│   ├── notes-misc.jsp
│   ├── flashcards.jsp
│   └── profile.jsp
├── sql/
│   ├── 01_create_schema_and_seed.sql
│   ├── 02_alter_tables_and_code_questions.sql
│   └── 03_insert_extra_questions.sql
├── scripts/
│   ├── generate_notes_oop.py
│   ├── fix_jsp_encoding.py
│   ├── fix_notes_layout.py
│   ├── fix_navbar_profile.py
│   ├── fix_navbar_order_and_css.py
│   ├── inject_navbar_html.py
│   └── generate_all_jsp_pages.py
├── DatabaseSetup.java
├── VerifyQuestions.java
├── RunQuizSystem.bat
└── README.md
```

---

## 🏃 Running the Project

Use the provided automation script:
```sh
.\RunQuizSystem.bat
```
This script will:
- Compile all Java files.
- Copy web content to the Tomcat webapps directory.
- Restart the Tomcat server automatically.

---
*Created with ❤️ for Java Enthusiasts.*
