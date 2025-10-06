#!/bin/bash

# Cleanup function to kill both processes
cleanup() {
    echo ""
    echo "Shutting down processes on ports 8012 and 8009..."
    lsof -ti:8012 | xargs kill -9 2>/dev/null || true
    lsof -ti:8009 | xargs kill -9 2>/dev/null || true
    exit 0
}

# Set up trap to call cleanup on script exit, Ctrl+C, or termination
trap cleanup EXIT INT TERM

# Kill any processes running on ports 8012 and 8009
echo "Checking for processes on ports 8012 and 8009..."
lsof -ti:8012 | xargs kill -9 2>/dev/null || true
lsof -ti:8009 | xargs kill -9 2>/dev/null || true

# Start the HTTP server in the background
(cd assets && sh server.sh) &
echo "HTTP server now running on port 8012"

# Run elm-watch hot
echo "Starting elm-watch hot on port 8009"
npx elm-watch hot