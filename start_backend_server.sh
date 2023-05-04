#!/bin/sh

# Get the script's absolute path
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Change to the backend directory
cd "$SCRIPT_DIR/backend" || exit

# Execute the Deno command
deno run --allow-net --allow-env --allow-read index.ts