#!/bin/bash

# Kill any process running on port 56907 (elm-watch default port)
lsof -ti:56907 | xargs kill -9 2>/dev/null || true

# Start elm-watch hot in the background
npx elm-watch hot &

# Store the PID so we can reference it
ELM_WATCH_PID=$!

# Wait a bit for elm-watch to compile and start the server
sleep 3

# Open Firefox with the app
open -a /Applications/Firefox.app assets/index.html

# Wait for elm-watch to finish (it will run until you Ctrl+C)
wait $ELM_WATCH_PID
