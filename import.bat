@echo off
setlocal enabledelayedexpansion

echo =========================================================
echo  Railway MySQL Schema ^& Data Import Tool (Windows)
echo =========================================================
echo.

if "%MYSQLHOST%"=="" (
    set /p "MYSQLHOST=Enter Railway MySQL Host (e.g. autorack.proxy.rlwy.net): "
)

if "%MYSQLPASSWORD%"=="" (
    set /p "MYSQLPASSWORD=Enter Railway MySQL Password: "
)

if "%MYSQLPORT%"=="" (
    set /p "MYSQLPORT=Enter Railway MySQL Port [default 3306]: "
)
if "%MYSQLPORT%"=="" set "MYSQLPORT=3306"

if "%MYSQLDATABASE%"=="" (
    set /p "MYSQLDATABASE=Enter Railway Database Name [default railway]: "
)
if "%MYSQLDATABASE%"=="" set "MYSQLDATABASE=railway"

if "%MYSQLUSER%"=="" (
    set /p "MYSQLUSER=Enter Railway Username [default root]: "
)
if "%MYSQLUSER%"=="" set "MYSQLUSER=root"

set "SQL_FILE=sql\01_create_schema_and_seed.sql"

if not exist "%SQL_FILE%" (
    echo [ERROR] %SQL_FILE% not found. Ensure you are running this from project root.
    pause
    exit /b 1
)

echo.
echo Connecting to Railway MySQL at %MYSQLHOST%:%MYSQLPORT%...

mysql --host="%MYSQLHOST%" --port="%MYSQLPORT%" --user="%MYSQLUSER%" --password="%MYSQLPASSWORD%" "%MYSQLDATABASE%" < "%SQL_FILE%"

if errorlevel 1 (
    echo.
    echo [ERROR] Import failed. Check your host, port, credentials, or mysql client path.
    pause
    exit /b 1
)

echo.
echo [SUCCESS] Database schema and seed data imported successfully into Railway!
echo.
pause
