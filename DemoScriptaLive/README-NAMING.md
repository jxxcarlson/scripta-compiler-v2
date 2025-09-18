# Scripta Naming Convention

## Product Names

- **Scripta Live** - Web-based versions that run in a browser
  - Uses either LocalStorage or SQLite WASM for persistence
  - Accessible via URL or local file

- **Scripta Desktop** - Full-featured desktop application
  - Built with Tauri
  - Uses native SQLite database
  - Best performance and reliability
  - Data stored in system app directory

- **Scripta Local** - Lightweight desktop application
  - Built with Tauri
  - Uses browser LocalStorage within the app
  - Simpler architecture
  - Data stored in Tauri's webview localStorage

## Quick Reference

| Version | Platform | Storage | Use Case |
|---------|----------|---------|----------|
| Scripta Live | Web Browser | LocalStorage/SQLite WASM | Online editing, sharing |
| Scripta Desktop | Native App | SQLite Database | Professional work, large documents |
| Scripta Local | Native App | LocalStorage | Personal notes, simple documents |

## Development Commands

```bash
# Scripta Live (Web versions)
npm run build-live         # LocalStorage version
npm run build-live-sqlite  # SQLite WASM version
./serve.sh                 # Run local server for SQLite version

# Scripta Desktop (Tauri + Native SQLite)
npm run dev-desktop    # Development mode
npm run build-desktop  # Production build

# Scripta Local (Tauri + LocalStorage)
npm run dev-local    # Development mode
npm run build-local  # Production build

# Build all versions
npm run build-all
```