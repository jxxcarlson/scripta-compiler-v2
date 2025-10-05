#!/bin/bash

# Simple HTTP server script for Scripta Live
# This helps avoid file:// protocol issues with SQLite WASM

echo "Starting Scripta Live server..."
echo ""
echo "Available versions:"
echo "  http://localhost:8000/assets/index.html         - Original version"
echo "  http://localhost:8000/assets/index-local.html   - LocalStorage version"
echo "  http://localhost:8000/assets/index-sqlite.html  - SQLite version"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Check if Python 3 is available
if command -v python3 &> /dev/null; then
    python3 -m http.server 8007
elif command -v python &> /dev/null; then
    python -m SimpleHTTPServer 8007
else
    echo "Error: Python is not installed. Please install Python to run the server."
    exit 1
fi