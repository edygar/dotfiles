#!/usr/bin/env zsh
#
# wallpaper.zsh
#
# Fetches and sets dark space/astronomy wallpapers.
# Uses NASA APOD (Astronomy Picture of the Day) API + Unsplash for variety.
#
# Usage:
#   wallpaper.zsh                    # fetch and set next wallpaper
#   wallpaper.zsh "nebula dark"      # fetch with custom Unsplash query
#   wallpaper.zsh init               # download initial batch
#
# Schedule with crontab:
#   0 * * * * ~/.local/bin/wallpaper.zsh

WALLPAPER_DIR="$HOME/.config/wallpapers"
STATE_FILE="$WALLPAPER_DIR/.current"
KEY_FILE="$WALLPAPER_DIR/.unsplash-key"
MAX_WALLPAPERS=30

# Rotate through different queries for variety
QUERIES=(
  "space nebula dark"
  "galaxy stars night"
  "astronomy dark"
  "milky way dark"
  "black hole space"
  "deep space stars"
  "cosmos dark"
  "planet space dark"
  "aurora borealis night"
  "northern lights dark"
)

mkdir -p "$WALLPAPER_DIR"

get_current_workspace() {
  /opt/homebrew/bin/aerospace list-workspaces --focused 2>/dev/null
}

update_workspace_map() {
  local wallpaper="$1"
  local ws=$(get_current_workspace)
  if [[ -n "$ws" ]] && [[ -f "$WALLPAPER_DIR/.workspace-map" ]]; then
    grep -v "^${ws}=" "$WALLPAPER_DIR/.workspace-map" > "$WALLPAPER_DIR/.workspace-map.tmp" 2>/dev/null
    mv "$WALLPAPER_DIR/.workspace-map.tmp" "$WALLPAPER_DIR/.workspace-map"
    echo "${ws}=${wallpaper}" >> "$WALLPAPER_DIR/.workspace-map"
  fi
}

get_api_key() {
  [[ -f "$KEY_FILE" ]] && cat "$KEY_FILE"
}

# Fetch from NASA APOD (Astronomy Picture of the Day) - free, no API key needed for demo
fetch_apod() {
  local count=${1:-1}
  local url="https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&count=$count"
  local response=$(curl -sL "$url" 2>/dev/null)

  echo "$response" | python3 -c "
import sys, json
data = json.load(sys.stdin)
if isinstance(data, list):
    for item in data:
        if item.get('media_type') == 'image' and item.get('hdurl'):
            print(item['hdurl'])
elif isinstance(data, dict) and data.get('media_type') == 'image' and data.get('hdurl'):
    print(data['hdurl'])
" 2>/dev/null
}

# Fetch from Unsplash with variety
fetch_unsplash() {
  local query="${1:-space dark}"
  local api_key=$(get_api_key)

  if [[ -z "$api_key" ]]; then
    return 1
  fi

  local url="https://api.unsplash.com/photos/random?query=${query// /+}&orientation=landscape&count=1"
  local response=$(curl -sL -H "Authorization: Client-ID $api_key" "$url")

  local image_url=$(echo "$response" | python3 -c "
import sys, json
d = json.load(sys.stdin)
if isinstance(d, list) and len(d) > 0:
    print(d[0]['urls']['full'])
elif isinstance(d, dict) and 'urls' in d:
    print(d['urls']['full'])
" 2>/dev/null)

  if [[ -n "$image_url" ]]; then
    echo "${image_url}&w=2560&q=80&fm=jpg"
  fi
}

fetch_wallpaper() {
  local timestamp=$(date +%s)
  local filename="$WALLPAPER_DIR/wallpaper_${timestamp}.jpg"

  # Alternate between NASA APOD and Unsplash
  local hour=$(date +%H)
  local image_url=""

  if [[ $(( hour % 2 )) -eq 0 ]]; then
    # Try NASA APOD first
    image_url=$(fetch_apod 1 | head -1)
  fi

  if [[ -z "$image_url" ]]; then
    # Fallback to Unsplash with rotating query
    local query_idx=$(( timestamp % ${#QUERIES} ))
    local query="${QUERIES[$query_idx]}"
    image_url=$(fetch_unsplash "$query")
  fi

  if [[ -z "$image_url" ]]; then
    # Last resort: try APOD again
    image_url=$(fetch_apod 1 | head -1)
  fi

  if [[ -z "$image_url" ]]; then
    echo "Failed to fetch wallpaper"
    return 1
  fi

  curl -sL -o "$filename" "$image_url" 2>/dev/null

  if file "$filename" | grep -q "JPEG\|PNG"; then
    local files=("$WALLPAPER_DIR"/wallpaper_*.*(.N))
    if [[ ${#files} -gt $MAX_WALLPAPERS ]]; then
      rm -f "${files[1]}"
    fi
    echo "$filename"
  else
    rm -f "$filename"
    echo "Downloaded file is not a valid image"
    return 1
  fi
}

set_wallpaper() {
  local files=("$WALLPAPER_DIR"/wallpaper_*.*(.N))
  local count=${#files}

  if [[ $count -gt 0 ]] && [[ -f "$STATE_FILE" ]]; then
    local current=$(cat "$STATE_FILE")
    local next=$(( (current % count) + 1 ))
    echo "$next" > "$STATE_FILE"
    local wallpaper="${files[$next]}"
    if file "$wallpaper" | grep -q "JPEG\|PNG"; then
      echo "Setting wallpaper: $(basename "$wallpaper")"
      wallpaper set "$wallpaper"
      update_workspace_map "$wallpaper"
      return 0
    fi
  fi

  printf "Fetching new wallpaper... "
  local wallpaper=$(fetch_wallpaper)
  if [[ $? -eq 0 ]] && [[ -n "$wallpaper" ]]; then
    echo "done"
    echo "Setting wallpaper: $(basename "$wallpaper")"
    wallpaper set "$wallpaper"
    update_workspace_map "$wallpaper"
    local files=("$WALLPAPER_DIR"/wallpaper_*.*(.N))
    echo "${#files}" > "$STATE_FILE"
  else
    echo "failed"
    return 1
  fi
}

case "${1:-}" in
  init)
    echo "Downloading initial wallpapers..."
    # Mix of APOD and Unsplash
    for i in {1..3}; do
      printf "  [$i] APOD... "
      local wallpaper=$(fetch_wallpaper)
      if [[ $? -eq 0 ]]; then
        echo "$(basename "$wallpaper")"
      else
        echo "FAILED"
      fi
      sleep 1
    done
    for i in {4..6}; do
      printf "  [$i] Unsplash... "
      local query_idx=$(( i % ${#QUERIES} ))
      local url=$(fetch_unsplash "${QUERIES[$query_idx]}")
      if [[ -n "$url" ]]; then
        local ts=$(date +%s)
        local fn="$WALLPAPER_DIR/wallpaper_${ts}_unsplash.jpg"
        curl -sL -o "$fn" "$url" 2>/dev/null
        if file "$fn" | grep -q "JPEG"; then
          echo "$(basename "$fn")"
        else
          rm -f "$fn"
          echo "FAILED"
        fi
      else
        echo "FAILED"
      fi
      sleep 1
    done
    set_wallpaper
    ;;
  *" "*|*)
    # Custom query - use Unsplash
    printf "Fetching: %s... " "$1"
    local url=$(fetch_unsplash "$1")
    if [[ -n "$url" ]]; then
      local ts=$(date +%s)
      local fn="$WALLPAPER_DIR/wallpaper_${ts}.jpg"
      curl -sL -o "$fn" "$url" 2>/dev/null
      if file "$fn" | grep -q "JPEG"; then
        echo "done"
        wallpaper set "$fn"
        update_workspace_map "$fn"
      else
        rm -f "$fn"
        echo "failed"
      fi
    else
      echo "failed"
    fi
    ;;
  "")
    set_wallpaper
    ;;
esac
