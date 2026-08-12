@echo off
setlocal
set "MVNW_REPOURL=https://repo.maven.apache.org/maven2"
set "MVNW_VERSION=0.5.6"
set "MVNW_JAR=.mvn\wrapper\maven-wrapper.jar"
set "MVNW_PROPERTIES=.mvn\wrapper\maven-wrapper.properties"

rem Execute the Maven Wrapper JAR with any arguments passed to this script
java -jar "%MVNW_JAR%" %*

endlocal
