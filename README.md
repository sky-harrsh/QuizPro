# QuizPro

A Java web app for practicing Java through categorized quizzes, study notes, flashcards, and results.

Live site: https://quizpro-5s5x.onrender.com  
Source: https://github.com/sky-harrsh/QuizPro

## Features

- Quizzes for Core Java, OOP, Advanced Java, and Miscellaneous topics.
- Seeded practice questions, study notes, and flashcards.
- Result summaries and answer review.
- Optional AI-generated questions when an Anthropic API key is configured.

## Stack

- Java 17, JSP, Servlets, and JDBC
- MySQL Connector/J 9.2.0
- Maven and Apache Tomcat 9
- MySQL-compatible database; the current production deployment uses TiDB Cloud Starter.
- Docker deployment on Render

## Database setup

The SQL setup script is sql/01_create_schema_and_seed.sql. It creates the quizdb database and the users, questions, and results tables, then inserts 60 sample questions (15 per category).

For a fresh database, run the script once. It uses CREATE TABLE IF NOT EXISTS, but its question INSERT is not idempotent; running it again adds duplicate questions.

For a local MySQL-compatible server, from the repository root:

~~~sh
mysql -u root -p < sql/01_create_schema_and_seed.sql
~~~

For TiDB Cloud Starter, select the main branch and quizdb in the TiDB Cloud SQL Editor, then run the script. Public-endpoint connections require TLS.

## Connection configuration

DBConnection reads these environment variables:

- MYSQLHOST — database host
- MYSQLPORT — database port (TiDB Cloud Starter uses 4000)
- MYSQLDATABASE — database name (quizdb)
- MYSQLUSER — database user, including the TiDB instance prefix when required
- MYSQLPASSWORD — database password

Do not commit passwords or put them in this README. Store them in your deployment platform's secret environment-variable settings.

The JDBC URL uses sslMode=VERIFY_IDENTITY so the server certificate and hostname are validated. TiDB Cloud Starter supports TLS 1.2 and 1.3; Java uses its system root certificates, so a separate CA file is not normally required for Starter. The local database must also support certificate-validated TLS.

## Build locally

Requires JDK 17 or newer and Maven 3.8 or newer. Build the WAR from the repository root:

~~~sh
./mvnw clean package
~~~

On Windows, use:

~~~bat
mvnw.cmd clean package
~~~

The WAR is built as target/OnlineQuizSystem.war. For local runtime use, configure the database environment variables before launching Tomcat.

## Deploy on Render

The repository includes a Dockerfile for Render. Connect the GitHub repository to a Docker web service, then configure the five MYSQL variables above in the service's Environment settings. Keep MYSQLPASSWORD secret. The service builds with Java 17 and Tomcat 9.

With automatic deploys enabled, commits to the configured branch start a new build and deployment. Keep database credentials out of GitHub and use only database services whose pricing and limits fit your account.

## Optional AI features

Set ANTHROPIC_API_KEY in the deployment environment to enable AI-generated quiz questions and answer explanations. Without it, the seeded database questions remain available and the core quiz flow does not require an AI API key.

## Project layout

~~~text
src/main/java/       Java database helper, models, and servlets
src/main/webapp/     JSP pages, assets, and WEB-INF configuration
sql/                 database schema and seeded questions
Dockerfile           multi-stage Maven/Tomcat image for Render
pom.xml              Maven dependencies and build configuration
~~~
