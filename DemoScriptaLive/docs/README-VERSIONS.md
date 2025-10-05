# Scripta - Version Guide

This project contains multiple versions of Scripta with different storage backends:

## Web Versions - "Scripta Live"

### 1. Original Version (LocalStorage)
- **Entry**: `src/Main.elm`
- **HTML**: `assets/index.html`
- **Storage**: Browser localStorage
- **Build**: `npm run build-elm`
- **Run**: Open `assets/index.html` in browser

### 2. Modular LocalStorage Version
- **Entry**: `src/MainLocal.elm`
- **HTML**: `assets/index-local.html`
- **Storage**: Browser localStorage via storage abstraction
- **Build**: `npm run build-live`
- **Run**: Open `assets/index-local.html` in browser

### 3. SQLite Web Version
- **Entry**: `src/MainSQLite.elm`
- **HTML**: `assets/index-sqlite.html`
- **Storage**: SQL.js (SQLite WASM) with localStorage persistence
- **Build**: `npm run build-live-sqlite`
- **Run**: `./serve.sh` then open http://localhost:8000/assets/index-sqlite.html

## Desktop Versions (Tauri)

### 4. Scripta Desktop - Tauri with Native SQLite
- **Entry**: `src/MainTauri.elm`
- **HTML**: `assets/index-tauri.html`
- **Storage**: Native SQLite database (stored in app data directory)
- **Build**: `npm run build-desktop`
- **Dev**: `npm run dev-desktop`
- **Database Location**: 
  - macOS: `~/Library/Application Support/com.scripta.live/scripta.db`
  - Windows: `%APPDATA%\com.scripta.live\scripta.db`
  - Linux: `~/.config/com.scripta.live/scripta.db`

### 5. Scripta Local - Tauri with LocalStorage
- **Entry**: `src/Main.elm`
- **HTML**: `assets/index.html` (wrapped in Tauri)
- **Storage**: Browser localStorage (within Tauri webview)
- **Build**: `npm run build-local`
- **Dev**: `npm run dev-local`

## Quick Commands

```bash
# Build all web versions
npm run build-all

# Run web server for SQLite web version
./serve.sh

# Development mode for Tauri with SQLite
npm run dev-tauri-sqlite

# Build Tauri app with SQLite for distribution
npm run build-tauri-sqlite
```

## Which Version to Use?

- **Scripta Live** (Web deployment): Use the modular LocalStorage version (`MainLocal.elm`) or SQLite web version (`MainSQLite.elm`)
- **Scripta Desktop** (Desktop app with best performance): Use Tauri with native SQLite (`MainTauri.elm`)
- **Scripta Local** (Simple desktop app): Use Tauri with LocalStorage (`Main.elm`)
- **Legacy support**: Use original web version (`Main.elm`)

## Switching Between Tauri Versions

To switch which version Tauri uses, update `src-tauri/tauri.conf.json`:

For SQLite version:
```json
"beforeBuildCommand": "elm make src/MainTauri.elm --output=assets/main-tauri.js",
"devPath": "../assets/index-tauri.html",
```

For original LocalStorage version:
```json
"beforeBuildCommand": "elm make src/Main.elm --output=assets/main.js",
"devPath": "../assets/index.html",
```