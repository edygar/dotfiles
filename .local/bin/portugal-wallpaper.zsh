#!/usr/bin/env zsh
#
# portugal-wallpaper.zsh
#
# Rotates through dark-themed Portugal city skyline wallpapers every hour.
# Downloaded from Unsplash (free to use, no API key needed for source URLs).
#
# Usage:
#   portugal-wallpaper.zsh        # set next wallpaper
#   portugal-wallpaper.zsh init   # download all wallpapers and set first
#
# Schedule with crontab:
#   0 * * * * ~/.local/bin/portugal-wallpaper.zsh

WALLPAPER_DIR="$HOME/.config/wallpapers/portugal"
STATE_FILE="$WALLPAPER_DIR/.current"
mkdir -p "$WALLPAPER_DIR"

# Dark-themed Portugal city skylines from Unsplash (royalty-free)
# Format: "description|url"
WALLPAPERS=(
  "Lisbon sunset|https://images.unsplash.com/photo-1555881400-74d7acaacd8c?w=2560&q=80&fm=jpg"
  "Porto bridge night|https://images.unsplash.com/photo-1583509711405-405e7e6e5b8e?w=2560&q=80&fm=jpg"
  "Lisbon rooftops|https://images.unsplash.com/photo-1513735492246-483525079686?w=2560&q=80&fm=jpg"
  "Porto dusk|https://images.unsplash.com/photo-1591568165842-1a7c9b6b3b6a?w=2560&q=80&fm=jpg"
  "Lisbon tram street|https://images.unsplash.com/photo-1518733057094-95b53143d2b7?w=2560&q=80&fm=jpg"
  "Porto river|https://images.unsplash.com/photo-1547546095-7d0b4e6b5b8e?w=2560&q=80&fm=jpg"
  "Lisbon night cityscape|https://images.unsplash.com/photo-1574925366236-08bdf5a3a8b7?w=2560&q=80&fm=jpg"
  "Porto lights|https://images.unsplash.com/photo-1505451675675-1f4c3b3e3b1e?w=2560&q=80&fm=jpg"
)

download_all() {
  echo "Downloading Portugal wallpapers..."
  for i in {1..${#WALLPAPERS}}; do
    local entry="${WALLPAPERS[$i]}"
    local desc="${entry%%|*}"
    local url="${entry##*|}"
    local filename=$(printf "%s/portugal_%02d.jpg" "$WALLPAPER_DIR" "$i")

    if [[ -f "$filename" ]]; then
      echo "  [$i/${#WALLPAPERS}] Already exists: $desc"
      continue
    fi

    printf "  [$i/${#WALLPAPERS}] Downloading: $desc... "
    if curl -sL "$url" -o "$filename" 2>/dev/null; then
      echo "done"
    else
      echo "FAILED"
      rm -f "$filename"
    fi
  done
  echo "Download complete."
}

set_next() {
  local files=("$WALLPAPER_DIR"/portugal_*.jpg(N))
  local count=${#files}

  if [[ $count -eq 0 ]]; then
    echo "No wallpapers found. Run with 'init' first."
    return 1
  fi

  local current=1
  if [[ -f "$STATE_FILE" ]]; then
    current=$(cat "$STATE_FILE")
    current=$(( (current % count) + 1 ))
  fi

  local wallpaper="${files[$current]}"
  echo "$current" > "$STATE_FILE"

  echo "Setting wallpaper: $(basename "$wallpaper")"
  wallpaper set "$wallpaper"
}

case "${1:-next}" in
  init)
    download_all
    set_next
    ;;
  next|"")
    set_next
    ;;
  *)
    echo "Usage: $0 [init|next]"
    ;;
esac
