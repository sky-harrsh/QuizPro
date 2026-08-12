#!/usr/bin/env sh
# Maven Wrapper script (Unix)
# This script delegates to the Maven Wrapper JAR.
# It works on Linux/macOS and also in Git Bash on Windows.

# Resolve the project root directory (the directory containing this script)
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

# Execute the wrapper JAR with any arguments passed to this script
exec java -jar "$PROJECT_ROOT/.mvn/wrapper/maven-wrapper.jar" "$@"
