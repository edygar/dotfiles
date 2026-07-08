#!/usr/bin/env zsh
#
# wallpaper.zsh
#
# Fetches and sets dark-themed wallpapers from Unsplash on demand.
# Uses the Unsplash API to search for random images matching a query.
#
# Usage:
#   wallpaper.zsh                    # fetch and set next wallpaper (default query)
#   wallpaper.zsh "dark city night"  # fetch with custom query
#   wallpaper.zsh init               # download initial batch
#
# Schedule with crontab:
#   0 * * * * ~/.local/bin/wallpaper.zsh

WALLPAPER_DIR="$HOME/.config/wallpapers"
STATE_FILE="$WALLPAPER_DIR/.current"
KEY_FILE="$WALLPAPER_DIR/.unsplash-key"
DEFAULT_QUERY="dark city skyline night"
MAX_WALLPAPERS=20

mkdir -p "$WALLPAPER_DIR"

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

  # Append size params
  image_url="${image_url}&w=2560&q=80&fm=jpg"

  local timestamp=$(date +%s)
  local filename="$WALLPAPER_DIR/wallpaper_${timestamp}.jpg"

  curl -sL -o "$filename" "$image_url" 2>/dev/null

  if file "$filename" | grep -q "JPEG"; then
    # Rotate: remove oldest if exceeding max
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

  # Try to use an existing wallpaper first (rotate through them)
  local files=("$WALLPAPER_DIR"/wallpaper_*.jpg(N))
  local count=${#files}

  if [[ $count -gt 0 ]] && [[ -f "$STATE_FILE" ]]; then
    local current=$(cat "$STATE_FILE")
    local next=$(( (current % count) + 1 ))
    echo "$next" > "$STATE_FILE"
    local wallpaper="${files[$next]}"
    if file "$wallpaper" | grep -q "JPEG"; then
      echo "Setting wallpaper: $(basename "$wallpaper")"
      wallpaper set "$wallpaper"
      return 0
    fi
  fi

  # Fetch a new one
  printf "Fetching new wallpaper (query: %s)... " "$query"
  local wallpaper=$(fetch_wallpaper "$query")
  if [[ $? -eq 0 ]] && [[ -n "$wallpaper" ]]; then
    echo "done"
    echo "Setting wallpaper: $(basename "$wallpaper")"
    wallpaper set "$wallpaper"
    local files=("$WALLPAPER_DIR"/wallpaper_*.jpg(N))
    echo "${#files}" > "$STATE_FILE"
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
