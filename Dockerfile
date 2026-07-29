# ─── Stage 1: Build Maven WAR package ────────────────────────
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build production WAR artifact
RUN mvn clean package -DskipTests

# ─── Stage 2: Production Apache Tomcat 9 Runtime ─────────────
FROM tomcat:9.0-jre17-temurin

# Remove default Tomcat ROOT application
RUN rm -rf /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/webapps/ROOT.war

# Copy generated WAR artifact as ROOT.war (wildcard handles any artifact name)
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Copy entrypoint script for dynamic PORT binding (Render support)
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose port 8080 by default
EXPOSE 8080

# Launch Tomcat using entrypoint script
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
