# SQLite Version of Scripta Live

The SQLite version uses SQL.js (SQLite compiled to WebAssembly) for browser-based database storage with localStorage persistence.

## Important: Running the SQLite Version

Due to browser security restrictions, the SQLite version requires running from a web server (not file:// protocol).

### Quick Start

1. Build the SQLite version:
   ```bash
   npm run build-sqlite
   ```

2. Start the local server:
   ```bash
   ./serve.sh
   ```

3. Open in your browser:
   ```
   http://localhost:8000/assets/index-sqlite.html
   ```

## How It Works

- Uses SQL.js (SQLite compiled to WebAssembly)
- Database is stored in browser's localStorage as base64
- Data persists across browser sessions
- All operations happen in the browser (no server required)

## Differences from LocalStorage Version

- **LocalStorage version**: Simple key-value storage, good for basic needs
- **SQLite version**: Full SQL database in the browser, better for complex queries and data relationships

## Troubleshooting

If you see "Failed to initialize SQLite":
1. Make sure you're running from a web server (use ./serve.sh)
2. Check browser console for detailed error messages
3. Try clearing localStorage if database is corrupted

## Browser Compatibility

Works in modern browsers that support:
- WebAssembly
- localStorage
- ES6+ JavaScript features