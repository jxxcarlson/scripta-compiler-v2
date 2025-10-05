# Scripta Live Desktop Application

This is the Tauri desktop version of Scripta Live, providing a native desktop experience for Windows, macOS, and Linux.

## Prerequisites

- Node.js and npm
- Rust and Cargo (install from https://rustup.rs/)
- Elm (install with `npm install -g elm`)

## Development Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Build the Rust dependencies:
   ```bash
   cd src-tauri
   cargo build
   cd ..
   ```

## Running the Application

### Development Mode
```bash
npm run dev
```

This will:
1. Build the Elm application
2. Start the Tauri development server
3. Open the desktop application

### Building for Production
```bash
npm run build
```

This creates platform-specific installers in `src-tauri/target/release/bundle/`.

## File Structure

```
DemoScripta/
├── src/                    # Elm source files
├── assets/                 # Static assets
│   ├── index-tauri.html   # Tauri-specific HTML entry
│   └── main.js            # Compiled Elm output
├── src-tauri/             # Rust/Tauri backend
│   ├── src/
│   │   └── main.rs        # Main Rust entry point
│   ├── Cargo.toml         # Rust dependencies
│   └── tauri.conf.json    # Tauri configuration
└── package.json           # Node.js scripts

```

## Features

- Native desktop window management
- Local storage for documents
- File system access (when needed)
- Cross-platform support
- Native menus and dialogs (can be added)

## Differences from Web Version

The desktop version:
- Uses localStorage for document storage (same as web)
- Runs as a standalone application
- Can be extended with native features like:
  - File system access for import/export
  - Native menus
  - System tray integration
  - OS-specific features

## Troubleshooting

1. If you get Rust compilation errors, ensure you have the latest Rust version:
   ```bash
   rustup update
   ```

2. If the window doesn't open, check the console for errors:
   ```bash
   npm run dev
   ```

3. For macOS code signing issues during development, the app runs unsigned by default.

## Distribution

The `npm run build` command creates installers for your platform:
- **Windows**: `.msi` installer
- **macOS**: `.dmg` disk image
- **Linux**: `.deb` and `.AppImage` files

For distributing to users, you'll need to:
1. Code sign the applications (platform specific)
2. Notarize for macOS
3. Set up auto-updates (optional)