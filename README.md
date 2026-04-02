# Online Quiz System

This is a Java web application (Servlet & JSP) for an online quiz system.

## Setup Instructions

If you are seeing errors like `import javax.servlet cannot be resolved` in your `ResultServlet.java` or `LoginServlet.java`, it is because the Servlet libraries are missing from your classpath. Follow these steps to resolve it:

### 1. Database Setup
1. Setup a MySQL database running on `localhost:3306`.
2. Import the `database.sql` file provided to create the schema and dummy questions:
   ```sh
   mysql -u root -p < database.sql
   ```
3. If your MySQL root user has a password, update `src/db/DBConnection.java` with your password.

### 2. Download Required JARs
To run this application, you need the following JAR files. Place them inside the `WebContent/WEB-INF/lib` folder (you may need to create this folder):
- `servlet-api.jar` (Provided by Tomcat, found in `C:\tomcat\lib\servlet-api.jar` or similar path)
- `mysql-connector-java.jar` (MySQL JDBC Driver)

### 3. Setup in VS Code
If you are using Visual Studio Code:
1. Ensure you have the **Extension Pack for Java** installed.
2. In the "Java Projects" explorer panel at the bottom left, add your JARs to the "Referenced Libraries".
3. We have provided a `.vscode/settings.json` file which automatically looks for libraries inside `WebContent/WEB-INF/lib`. Once you place your jar files there, the errors should disappear!

### 4. Running the Project
- To deploy, you can copy the `WebContent` and `src` structure into your Apache Tomcat's `webapps` folder, or configure your IDE (Eclipse/IntelliJ/VSCode Community Server Connector) to run it locally on an embedded Tomcat server.
