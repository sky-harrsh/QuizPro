#!/bin/bash
# ─── Railway MySQL Database Import Script for Linux/macOS ───

echo "========================================================="
echo " Railway MySQL Schema & Data Import Tool"
echo "========================================================="
echo ""

# Read credentials from Environment Variables if present, otherwise prompt
MYSQLHOST="${MYSQLHOST:-}"
MYSQLPORT="${MYSQLPORT:-3306}"
MYSQLDATABASE="${MYSQLDATABASE:-railway}"
MYSQLUSER="${MYSQLUSER:-root}"
MYSQLPASSWORD="${MYSQLPASSWORD:-}"

if [ -z "$MYSQLHOST" ]; then
    read -p "Enter Railway MySQL Host (e.g. autorack.proxy.rlwy.net): " MYSQLHOST
fi

if [ -z "$MYSQLPASSWORD" ]; then
    read -sp "Enter Railway MySQL Password: " MYSQLPASSWORD
    echo ""
fi

if [ -z "$MYSQLPORT" ]; then
    read -p "Enter Railway MySQL Port [3306]: " MYSQLPORT
    MYSQLPORT="${MYSQLPORT:-3306}"
fi

if [ -z "$MYSQLDATABASE" ]; then
    read -p "Enter Railway Database Name [railway]: " MYSQLDATABASE
    MYSQLDATABASE="${MYSQLDATABASE:-railway}"
fi

if [ -z "$MYSQLUSER" ]; then
    read -p "Enter Railway Username [root]: " MYSQLUSER
    MYSQLUSER="${MYSQLUSER:-root}"
fi

SQL_FILE="sql/01_create_schema_and_seed.sql"

if [ ! -f "$SQL_FILE" ]; then
    echo "❌ Error: $SQL_FILE not found! Make sure you are running from the project root."
    exit 1
fi

echo ""
echo "Connecting to Railway MySQL at $MYSQLHOST:$MYSQLPORT..."

mysql --host="$MYSQLHOST" --port="$MYSQLPORT" --user="$MYSQLUSER" --password="$MYSQLPASSWORD" --database="$MYSQLDATABASE" < "$SQL_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Database schema and seed data imported successfully into Railway!"
else
    echo "❌ Import failed. Please check your credentials and network connection."
    exit 1
fi
