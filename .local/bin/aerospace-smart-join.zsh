#!/usr/bin/env zsh

set -u

direction="${1:-}"
aerospace="/opt/homebrew/bin/aerospace"
hs="/opt/homebrew/bin/hs"
jq="/opt/homebrew/bin/jq"
kitten="/Applications/kitty.app/Contents/MacOS/kitten"
log_file="/tmp/aerospace-smart-join.log"

if [[ ! -x "$kitten" ]]; then
  kitten="/opt/homebrew/bin/kitten"
fi

log() {
  printf '[%s] %s\n' "$(/bin/date -u '+%Y-%m-%dT%H:%M:%SZ')" "$*" >> "$log_file"
}

kitty_socket() {
  local socket
  socket="$(/bin/ls /tmp/kitty-socket-* 2>/dev/null | /usr/bin/head -n 1)"
  if [[ -S "$socket" ]]; then
    printf '%s' "$socket"
    return 0
  fi

  if [[ -S "/tmp/kitty-socket" ]]; then
    printf '%s' "/tmp/kitty-socket"
    return 0
  fi

  return 1
}

kitty_remote() {
  local socket
  socket="$(kitty_socket)" || return 1
  "$kitten" @ --to "unix:$socket" "$@"
}

if [[ -z "$direction" ]]; then
  exit 64
fi

focused_window() {
  "$aerospace" list-windows --focused --format '%{window-id}|%{app-name}|%{app-bundle-id}|%{window-title}' 2>/dev/null
}

field() {
  local line="$1"
  local index="$2"
  printf '%s' "$line" | /usr/bin/cut -d '|' -f "$index"
}

focus_window() {
  "$aerospace" focus --window-id "$1" >/dev/null 2>&1
  /bin/sleep 0.2
}

join_with() {
  focus_window "$source_id"
  "$aerospace" join-with "$direction" >/dev/null 2>&1
}

kitty_active_tab_for_platform_window() {
  local platform_window_id="$1"
  kitty_remote ls 2>/dev/null | "$jq" -r --argjson platformWindowId "$platform_window_id" '
    .[]
    | select(.platform_window_id == $platformWindowId)
    | (([.tabs[] | select(.is_active or .is_focused)] | first) // .tabs[0])
    | .id // empty
  ' | /usr/bin/head -n 1
}

merge_kitty_tabs() {
  local source_tab_id target_tab_id
  source_tab_id="$(kitty_active_tab_for_platform_window "$source_id")"
  target_tab_id="$(kitty_active_tab_for_platform_window "$target_id")"

  if [[ -z "$source_tab_id" || -z "$target_tab_id" ]]; then
    return 1
  fi

  kitty_remote detach-tab --match "id:$source_tab_id" --target-tab "id:$target_tab_id" >/dev/null 2>&1
}

chrome_frontmost_window_json() {
  osascript -l JavaScript <<'EOF'
const chrome = Application('Google Chrome');
const windows = chrome.windows();
if (!windows.length) {
  JSON.stringify(null);
} else {
  const w = windows[0];
  const tabs = w.tabs();
  const activeIndex = Number(w.activeTabIndex());
  const activeTab = tabs[activeIndex - 1] || tabs[0];
  JSON.stringify({
    id: Number(w.id()),
    title: w.name(),
    activeTabTitle: activeTab ? activeTab.title() : '',
    tabCount: tabs.length,
  });
}
EOF
}

merge_chrome_tabs() {
  local source_json target_json source_chrome_id target_chrome_id target_title target_full_title target_tab_count lua output

  focus_window "$source_id"
  source_json="$(chrome_frontmost_window_json)"

  focus_window "$target_id"
  target_json="$(chrome_frontmost_window_json)"

  source_chrome_id="$(printf '%s' "$source_json" | "$jq" -r '.id // empty')"
  target_chrome_id="$(printf '%s' "$target_json" | "$jq" -r '.id // empty')"
  target_title="$(printf '%s' "$target_json" | "$jq" -r '.title // empty')"
  target_full_title="$(printf '%s' "$target_json" | "$jq" -r '.activeTabTitle // empty')"
  target_tab_count="$(printf '%s' "$target_json" | "$jq" -r '.tabCount // empty')"

  log "chrome source aerospace=$source_id json=$source_json"
  log "chrome target aerospace=$target_id json=$target_json"

  if [[ -z "$source_chrome_id" || -z "$target_chrome_id" || "$source_chrome_id" == "$target_chrome_id" ]]; then
    log "chrome abort sourceChrome=$source_chrome_id targetChrome=$target_chrome_id"
    return 1
  fi

  lua="package.loaded[\"chrome-move-tab\"] = nil; require(\"chrome-move-tab\").doMoveToWindow($source_chrome_id, $target_chrome_id, $(printf '%s' "$target_title" | "$jq" -Rs .), $(printf '%s' "$target_full_title" | "$jq" -Rs .), $target_tab_count)"
  if ! output="$($hs -c "$lua" 2>&1)"; then
    log "chrome hs failed: $output"
    return 1
  fi
  log "chrome hs ok: $output"
}

source_line="$(focused_window)"
source_id="$(field "$source_line" 1)"
source_app="$(field "$source_line" 2)"
source_bundle="$(field "$source_line" 3)"

if [[ -z "$source_id" ]]; then
  exit 1
fi

if ! "$aerospace" focus "$direction" >/dev/null 2>&1; then
  join_with
  exit $?
fi

target_line="$(focused_window)"
target_id="$(field "$target_line" 1)"
target_app="$(field "$target_line" 2)"
target_bundle="$(field "$target_line" 3)"

if [[ -z "$target_id" || "$target_id" == "$source_id" ]]; then
  join_with
  exit $?
fi

if [[ "$source_bundle" == "net.kovidgoyal.kitty" && "$target_bundle" == "net.kovidgoyal.kitty" ]]; then
  if merge_kitty_tabs; then
    exit 0
  fi
fi

if [[ "$source_bundle" == "com.google.Chrome" && "$target_bundle" == "com.google.Chrome" ]]; then
  if merge_chrome_tabs; then
    exit 0
  fi
  focus_window "$source_id"
  exit 1
fi

join_with
