#!/usr/bin/env zsh
#
# wallpaper.zsh
#
# Fetches and sets dark space/astronomy wallpapers.
# Sources: NASA APOD (free), JWST API (free key), Unsplash (backup).
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
JWST_KEY_FILE="$WALLPAPER_DIR/.jwst-key"
MAX_WALLPAPERS=30

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

# NASA APOD - free, no API key (DEMO_KEY has rate limits but works)
fetch_apod() {
  local url="https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&count=1"
  local response=$(curl -sL "$url" 2>/dev/null)

  local image_url=$(echo "$response" | python3 -c "
import sys, json
data = json.load(sys.stdin)
if isinstance(data, list) and len(data) > 0:
    item = data[0]
    if item.get('media_type') == 'image':
        print(item.get('hdurl') or item.get('url', ''))
elif isinstance(data, dict):
    if data.get('media_type') == 'image':
        print(data.get('hdurl') or data.get('url', ''))
" 2>/dev/null)

  if [[ -n "$image_url" ]]; then
    echo "$image_url"
  fi
}

# JWST API - requires free key from https://jwstapi.com
fetch_jwst() {
  if [[ ! -f "$JWST_KEY_FILE" ]]; then
    return 1
  fi
  local key=$(cat "$JWST_KEY_FILE")
  # Get a random page to vary results
  local page=$(( (RANDOM % 50) + 1 ))
  local response=$(curl -sL -H "X-API-Key: $key" "https://api.jwstapi.com/all/type/jpg?page=${page}&per_page=20" 2>/dev/null)

  # Filter out thumbnails, get full-res images
  local image_url=$(echo "$response" | python3 -c "
import sys, json, random
data = json.load(sys.stdin)
body = data.get('body', [])
if isinstance(body, list):
    full_res = [item for item in body if 'thumb' not in item.get('id', '').lower()]
    if full_res:
        item = random.choice(full_res)
        print(item.get('location', ''))
" 2>/dev/null)

  if [[ -n "$image_url" ]]; then
    echo "$image_url"
  fi
}

# Unsplash - backup with space/astronomy queries
fetch_unsplash() {
  local query="${1:-space nebula dark}"
  local api_key=$(cat "$KEY_FILE" 2>/dev/null)
  [[ -z "$api_key" ]] && return 1

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
  local image_url=""

  # Try sources in order: APOD (best quality) > JWST (raw science) > Unsplash
  image_url=$(fetch_apod 2>/dev/null)

  if [[ -z "$image_url" ]]; then
    image_url=$(fetch_jwst 2>/dev/null)
  fi

  if [[ -z "$image_url" ]]; then
    local queries=("space nebula dark" "galaxy stars night" "milky way dark" "deep space" "cosmos dark")
    local idx=$(( timestamp % ${#queries} ))
    image_url=$(fetch_unsplash "${queries[$idx]}")
  fi

  if [[ -z "$image_url" ]]; then
    echo "Failed to fetch wallpaper from all sources"
    return 1
  fi

  curl -sL -o "$filename" "$image_url" 2>/dev/null

  if file "$filename" | grep -q "JPEG\|PNG\|GIF"; then
    # Check minimum resolution (skip tiny banners/strips)
    local width=$(sips -g pixelWidth "$filename" 2>/dev/null | awk '/pixelWidth/{print $2}')
    local height=$(sips -g pixelHeight "$filename" 2>/dev/null | awk '/pixelHeight/{print $2}')
    if [[ -n "$width" ]] && [[ -n "$height" ]] && [[ "$width" -ge 1000 ]] && [[ "$height" -ge 500 ]]; then
    local files=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,gif}(.N))
    if [[ ${#files} -gt $MAX_WALLPAPERS ]]; then
        rm -f "${files[1]}"
      fi
      echo "$filename"
    else
      rm -f "$filename"
      echo "Image too small (${width}x${height}), skipping"
      return 1
    fi
  else
    rm -f "$filename"
    echo "Downloaded file is not a valid image"
    return 1
  fi
}

set_wallpaper() {
  local files=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,gif}(.N))
  local count=${#files}

  if [[ $count -gt 0 ]] && [[ -f "$STATE_FILE" ]]; then
    local current=$(cat "$STATE_FILE")
    local next=$(( (current % count) + 1 ))
    echo "$next" > "$STATE_FILE"
    local wallpaper="${files[$next]}"
    if file "$wallpaper" | grep -q "JPEG\|PNG\|GIF"; then
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
    local files=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,gif}(.N))
    echo "${#files}" > "$STATE_FILE"
  else
    echo "failed"
    return 1
  fi
}

case "${1:-}" in
  init)
    echo "Downloading initial space wallpapers..."
    for i in {1..6}; do
      printf "  [$i] "
      local wallpaper=""
      # Alternate: APOD (beautiful processed) and JWST (raw science)
      if (( i % 2 == 0 )); then
        local jwst_url=$(fetch_jwst 2>/dev/null)
        if [[ -n "$jwst_url" ]]; then
          local ts=$(date +%s)
          local fn="$WALLPAPER_DIR/wallpaper_${ts}.jpg"
          curl -sL -o "$fn" "$jwst_url" 2>/dev/null
          if file "$fn" | grep -q "JPEG"; then
            wallpaper="$fn"
          else
            rm -f "$fn"
          fi
        fi
      fi
      if [[ -z "$wallpaper" ]]; then
        wallpaper=$(fetch_wallpaper)
      fi
      if [[ $? -eq 0 ]] && [[ -n "$wallpaper" ]]; then
        echo "$(basename "$wallpaper")"
      else
        echo "FAILED"
      fi
      sleep 1
    done
    set_wallpaper
    ;;
  *" "*|*)
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
