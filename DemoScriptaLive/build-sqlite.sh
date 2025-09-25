#!/bin/bash

# Build the SQLite version of Scripta Live
echo "Building SQLite version..."
npm run build-live-sqlite

if [ $? -eq 0 ]; then
    echo "✓ Build successful!"
    echo "SQLite version available at assets/main-sqlite.js"
else
    echo "✗ Build failed!"
    exit 1
fi