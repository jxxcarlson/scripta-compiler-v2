#!/bin/bash

# Kill any process running on port 56907
lsof -ti:56907 | xargs kill -9 2>/dev/null || true

# Start elm-watch in hot reload mode
npx elm-watch hot &
ELM_WATCH_PID=$!

# Wait a bit for the server to start
sleep 3

# Open in Firefox
open -a /Applications/Firefox.app assets/index.html

# Wait for elm-watch to finish (Ctrl+C to stop)
wait $ELM_WATCH_PID
