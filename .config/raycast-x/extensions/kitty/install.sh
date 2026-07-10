#!/usr/bin/env zsh
#
# install.sh — Build the Kitty Raycast extension
#
# Installs npm dependencies and compiles TypeScript entry points
# into Raycast-loadable JavaScript bundles.
#
# Usage:
#   ~/.config/raycast-x/extensions/kitty/install.sh

set -e

EXT_DIR="${0:A:h}"
RAYCAST_DIR="$HOME/.config/raycast-x/extensions/kitty"

echo "  [kitty-extension] Installing dependencies..."
cd "$EXT_DIR"
npm install --silent 2>&1 | tail -3

echo "  [kitty-extension] Building extension..."
mkdir -p "$RAYCAST_DIR"
cp "$EXT_DIR/package.json" "$EXT_DIR/tsconfig.json" "$EXT_DIR/raycast-env.d.ts" "$RAYCAST_DIR/"
cp -r "$EXT_DIR/assets" "$RAYCAST_DIR/"
npx ray build -o "$RAYCAST_DIR" 2>&1 | tail -1

echo "  [kitty-extension] Done."