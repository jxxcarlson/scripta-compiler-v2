#!/bin/bash
# Launch Scripta Desktop (standalone binary)
# This is a workaround for the bundled app PDF button issue

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
"$SCRIPT_DIR/src-tauri/target/release/scripta-live"