# Building Scripta Applications

## Overview

This project contains three distinct versions of Scripta, each with different storage backends and deployment targets:

1. **Scripta Live** - Web-based versions (browser)
2. **Scripta Desktop** - Native desktop app with SQLite database
3. **Scripta Local** - Native desktop app with LocalStorage

## Architecture Summary

### Shared Components
- `Common/Model.elm` - Shared model types and messages
- `Common/View.elm` - Shared view code (header, editor, rendered text, sidebar)
- `Storage/Interface.elm` - Storage abstraction layer
- `ScriptaV2` compiler - Core markup compilation engine

### Storage Implementations
- `Storage/Local.elm` - LocalStorage implementation
- `Storage/SQLite.elm` - SQLite WASM implementation (web)
- `Storage/Tauri.elm` - Native SQLite implementation (desktop)

## Building Each Version

### Scripta Live (Web Versions)

#### LocalStorage Version
```bash
npm run build-live
# Creates: assets/main-local.js
# Open: assets/index-local.html in browser
```

#### SQLite WASM Version
```bash
npm run build-live-sqlite
./serve.sh  # Required due to WASM security restrictions
# Creates: assets/main-sqlite.js
# Open: http://localhost:8000/assets/index-sqlite.html
```

### Scripta Desktop (Tauri + Native SQLite)

```bash
# Development
npm run dev-desktop

# Production build
npm run build-desktop

# Database location:
# macOS: ~/Library/Application Support/com.scripta.live/scripta.db
# Windows: %APPDATA%\com.scripta.live\scripta.db
# Linux: ~/.config/com.scripta.live/scripta.db
```

### Scripta Local (Tauri + LocalStorage)

```bash
# Development
npm run dev-local

# Production build
npm run build-local
```

## Technical Details

### Tauri Configuration
- Uses Tauri 2.0 RC
- Native SQLite via rusqlite with bundled feature
- Rust backend in `src-tauri/src/main.rs`
- Configuration in `src-tauri/tauri.conf.json`

### Key Differences Between Versions

| Feature | Scripta Live | Scripta Desktop | Scripta Local |
|---------|--------------|-----------------|---------------|
| Platform | Web Browser | Native App | Native App |
| Storage | LocalStorage/SQLite WASM | Native SQLite | LocalStorage |
| Persistence | Browser-specific | System database | App-specific |
| Performance | Good | Best | Good |
| File Access | Limited | Full | Limited |
| Offline | Yes (after load) | Yes | Yes |

### Development Workflow

1. **Make changes to shared code** in `Common/` directory
2. **Test web version first** with `npm run build-live`
3. **Test desktop version** with `npm run dev-desktop`
4. **Build all versions** with `npm run build-all`

### Troubleshooting

#### SQLite WASM Issues
- Must run from HTTP server, not file:// protocol
- Use `./serve.sh` for local testing
- Check browser console for initialization errors

#### Tauri Issues
- Check terminal output for Rust compilation errors
- Verify `window.__TAURI__` is available in browser console
- Database errors appear in terminal, not browser console

#### Editor Not Responding
- Verify CodeMirror initialization in console
- Check for `text-change` events when typing
- Ensure `loadDocumentIntoEditor` flag is set

#### Rendering Issues
- Check for syntax errors in document content (e.g., unmatched parentheses)
- Verify correct language/compiler is being used
- Check theme compatibility

### Adding New Features

1. **Storage-agnostic features**: Add to `Common/Model.elm` and `Common/View.elm`
2. **Storage-specific features**: Implement in each `Storage/*.elm` module
3. **Update all entry points**: `Main.elm`, `MainLocal.elm`, `MainSQLite.elm`, `MainTauri.elm`
4. **Test across all versions** before committing

## Where is the data stored?

The SQLite database for the Tauri app is stored in the system's app data directory. Here are the locations for each platform:

Database Locations

  macOS

  ```
  ~/Library/Application Support/com.scripta.live/scripta.db
  ```

  Windows

```
  %APPDATA%\com.scripta.live\scripta.db
  or typically:
  C:\Users\[Username]\AppData\Roaming\com.scripta.live\scripta.db
  ```

  Linux

```
  ~/.config/com.scripta.live/scripta.db
```


## Recent Features

### Last Saved Document Loading (All Versions)
- Apps now remember and automatically load the last saved document on startup
- Implemented in `Common/Model.elm` to work across all storage backends
- Each storage backend tracks the last saved document ID
- On app startup, if a last saved document exists, it's automatically loaded

## Summary

The modular architecture allows maximum code reuse while supporting different deployment targets. The storage abstraction layer makes it easy to add new storage backends. Tauri provides native performance and file system access for desktop versions, while web versions remain accessible and easy to deploy.