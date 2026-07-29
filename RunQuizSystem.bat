@echo off
setlocal

echo =========================================================
echo  Online Quiz System - Build ^& Deploy
echo =========================================================

REM ---- Paths (edit these if your setup differs) ----
set "PROJECT_DIR=%~dp0"
set "SRC_DIR=%PROJECT_DIR%src\main\java"
set "WEBCONTENT_DIR=%PROJECT_DIR%src\main\webapp"
set "CLASSES_DIR=%WEBCONTENT_DIR%\WEB-INF\classes"
set "LIB_DIR=%WEBCONTENT_DIR%\WEB-INF\lib"
set "TOMCAT_WEBAPPS=C:\xampp\tomcat\webapps\OnlineQuizSystem"
set "CATALINA_HOME=C:\xampp\tomcat"
set "JAVA_HOME=C:\Program Files\Java\jdk-25.0.2"
set "JAVAC=%JAVA_HOME%\bin\javac.exe"

echo.
echo [1/3] Compiling Java sources...

REM Build classpath for compilation: all JARs in WEB-INF/lib
set "CP=%CLASSES_DIR%"
for %%f in ("%LIB_DIR%\*.jar") do set "CP=!CP!;%%f"

REM Enable delayed expansion for the loop to work
setlocal enabledelayedexpansion
set "CP=%CLASSES_DIR%"
for %%f in ("%LIB_DIR%\*.jar") do set "CP=!CP!;%%f"

REM Find all .java files and compile them
dir /s /b "%SRC_DIR%\*.java" > "%TEMP%\sources.txt" 2>nul

"%JAVAC%" -cp "!CP!" -d "%CLASSES_DIR%" @"%TEMP%\sources.txt"
if errorlevel 1 (
    echo.
    echo [ERROR] Compilation FAILED. See errors above.
    echo         Fix the Java errors and try again.
    pause
    exit /b 1
)
echo [OK] Compilation successful.

echo.
echo [2/3] Deploying to Tomcat webapps...
if not exist "%TOMCAT_WEBAPPS%" mkdir "%TOMCAT_WEBAPPS%"
xcopy /E /I /Y "%WEBCONTENT_DIR%" "%TOMCAT_WEBAPPS%" > nul
echo [OK] Files copied to %TOMCAT_WEBAPPS%

echo.
echo [3/4] Stopping Tomcat if running...
call "%CATALINA_HOME%\bin\shutdown.bat" 2>nul
timeout /t 3 /nobreak > nul

echo.
echo [4/4] Starting Tomcat...
start "Tomcat" "%CATALINA_HOME%\bin\startup.bat"

echo.
echo Waiting for Tomcat to start (8 seconds)...
timeout /t 8 /nobreak > nul

echo.
echo Opening browser at http://localhost:8080/OnlineQuizSystem/
start http://localhost:8080/OnlineQuizSystem/

echo.
echo =========================================================
echo  Done! If login fails, check:
echo   1. MySQL is running (XAMPP Control Panel - start MySQL)
echo   2. sql\01_create_schema_and_seed.sql was imported into 'quizdb'
echo   3. DBConnection.java has the correct DB password
echo =========================================================
