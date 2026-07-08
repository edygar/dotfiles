#!/usr/bin/env zsh
#
# wallpaper.zsh
#
# Fetches and sets dark-themed wallpapers from Unsplash on demand.
# Updates the current aerospace workspace's wallpaper mapping.
#
# Usage:
#   wallpaper.zsh                    # fetch and set next wallpaper (default query)
#   wallpaper.zsh "dark city night"  # fetch with custom query
#   wallpaper.zsh init               # download initial batch
#
# Schedule with crontab:
#   0 * * * * ~/.local/bin/wallpaper.zsh

WALLPAPER_DIR="$HOME/.config/wallpapers"
WORKSPACE_MAP="$WALLPAPER_DIR/.workspace-map"
KEY_FILE="$WALLPAPER_DIR/.unsplash-key"
DEFAULT_QUERY="dark city skyline night"
MAX_WALLPAPERS=20

mkdir -p "$WALLPAPER_DIR"

get_current_workspace() {
  /opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null
}

update_workspace_map() {
  local wallpaper="$1"
  local ws=$(get_current_workspace)
  if [[ -n "$ws" ]] && [[ -f "$WORKSPACE_MAP" ]]; then
    grep -v "^${ws}=" "$WORKSPACE_MAP" > "$WORKSPACE_MAP.tmp" 2>/dev/null
    mv "$WORKSPACE_MAP.tmp" "$WORKSPACE_MAP"
    echo "${ws}=${wallpaper}" >> "$WORKSPACE_MAP"
  fi
}

get_api_key() {
  if [[ ! -f "$KEY_FILE" ]]; then
    echo "No Unsplash API key found at $KEY_FILE"
    echo "Get one at https://unsplash.com/developers"
    return 1
  fi
  cat "$KEY_FILE"
}

fetch_wallpaper() {
  local query="${1:-$DEFAULT_QUERY}"
  local api_key=$(get_api_key) || return 1

  local url="https://api.unsplash.com/photos/random?query=${query// /+}&orientation=landscape&count=1"
  local response=$(curl -sL -H "Authorization: Client-ID $api_key" "$url")

  local image_url=$(echo "$response" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d[0]['urls']['full'] if isinstance(d,list) else d['urls']['full'])" 2>/dev/null)

  if [[ -z "$image_url" ]]; then
    echo "Failed to fetch wallpaper from Unsplash"
    return 1
  fi

  image_url="${image_url}&w=2560&q=80&fm=jpg"

  local timestamp=$(date +%s)
  local filename="$WALLPAPER_DIR/wallpaper_${timestamp}.jpg"

  curl -sL -o "$filename" "$image_url" 2>/dev/null

  if file "$filename" | grep -q "JPEG"; then
    local files=("$WALLPAPER_DIR"/wallpaper_*.jpg(N))
    if [[ ${#files} -gt $MAX_WALLPAPERS ]]; then
      rm -f "${files[1]}"
    fi
    echo "$filename"
  else
    rm -f "$filename"
    echo "Downloaded file is not a valid JPEG"
    return 1
  fi
}

set_wallpaper() {
  local query="${1:-$DEFAULT_QUERY}"

  local files=("$WALLPAPER_DIR"/wallpaper_*.jpg(N))
  local count=${#files}

  if [[ $count -gt 0 ]] && [[ -f "$WALLPAPER_DIR/.current" ]]; then
    local current=$(cat "$WALLPAPER_DIR/.current")
    local next=$(( (current % count) + 1 ))
    echo "$next" > "$WALLPAPER_DIR/.current"
    local wallpaper="${files[$next]}"
    if file "$wallpaper" | grep -q "JPEG"; then
      echo "Setting wallpaper: $(basename "$wallpaper")"
      wallpaper set "$wallpaper"
      update_workspace_map "$wallpaper"
      return 0
    fi
  fi

  printf "Fetching new wallpaper (query: %s)... " "$query"
  local wallpaper=$(fetch_wallpaper "$query")
  if [[ $? -eq 0 ]] && [[ -n "$wallpaper" ]]; then
    echo "done"
    echo "Setting wallpaper: $(basename "$wallpaper")"
    wallpaper set "$wallpaper"
    update_workspace_map "$wallpaper"
    local files=("$WALLPAPER_DIR"/wallpaper_*.jpg(N))
    echo "${#files}" > "$WALLPAPER_DIR/.current"
  else
    echo "failed"
    return 1
  fi
}

case "${1:-}" in
  init)
    printf "Downloading initial wallpapers... "
    for i in {1..5}; do
      local wallpaper=$(fetch_wallpaper "$DEFAULT_QUERY")
      if [[ $? -eq 0 ]]; then
        echo "[$i] $(basename "$wallpaper")"
      else
        echo "[$i] FAILED"
      fi
    done
    set_wallpaper "$DEFAULT_QUERY"
    ;;
  *" "*|*)
    set_wallpaper "$1"
    ;;
  "")
    set_wallpaper "$DEFAULT_QUERY"
    ;;
esac
