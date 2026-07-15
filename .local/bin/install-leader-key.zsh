#!/usr/bin/env zsh

set -euo pipefail

repo_url="https://github.com/kevintraver/LeaderKey.git"
src_dir="$HOME/.cache/leader-key-fork"
derived_data_dir="$src_dir/.build"
app_name="Leader Key.app"
built_app="$derived_data_dir/Build/Products/Release/$app_name"
target_app="/Applications/$app_name"

echo "  Installing Leader Key fork..."

if ! xcodebuild -version >/dev/null 2>&1; then
  echo "  Skipped (full Xcode is required to build kevintraver/LeaderKey)."
  return 0 2>/dev/null || exit 0
fi

mkdir -p "$(dirname "$src_dir")"
if [[ -d "$src_dir/.git" ]]; then
  git -C "$src_dir" pull --ff-only
else
  git clone "$repo_url" "$src_dir"
fi

xcodebuild \
  -project "$src_dir/Leader Key.xcodeproj" \
  -scheme "Leader Key" \
  -configuration Release \
  -derivedDataPath "$derived_data_dir" \
  -skipPackagePluginValidation \
  -skipMacroValidation \
  CODE_SIGNING_ALLOWED=NO \
  build >/dev/null

if [[ ! -d "$built_app" ]]; then
  echo "  Build finished, but $built_app was not found."
  exit 1
fi

osascript -e 'quit app "Leader Key"' >/dev/null 2>&1 || true
rm -rf "$target_app"
ditto "$built_app" "$target_app"
xattr -dr com.apple.quarantine "$target_app" >/dev/null 2>&1 || true
open -a "Leader Key" >/dev/null 2>&1 || true

echo "  Installed $target_app from kevintraver/LeaderKey."
