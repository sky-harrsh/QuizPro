#!/bin/sh
set -e

# Dynamically configure Apache Tomcat port from PORT environment variable (defaults to 8080)
PORT="${PORT:-8080}"
echo "Configuring Apache Tomcat to listen on port ${PORT}..."

if [ -f /usr/local/tomcat/conf/server.xml ]; then
    sed -i "s/port=\"8080\"/port=\"${PORT}\"/g" /usr/local/tomcat/conf/server.xml
fi

echo "Starting Apache Tomcat..."
exec catalina.sh run
