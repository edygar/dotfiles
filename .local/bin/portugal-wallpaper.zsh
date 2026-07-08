#!/usr/bin/env zsh
#
# portugal-wallpaper.zsh
#
# Rotates through Portugal city skyline wallpapers every hour.
# Images from Wikimedia Commons (CC licensed, stable URLs).
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

WALLPAPERS=(
  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Lisbon_Skyline_%2845684560521%29.jpg/1280px-Lisbon_Skyline_%2845684560521%29.jpg"
  "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Lisbon_Skyline_%288558690509%29.jpg/1280px-Lisbon_Skyline_%288558690509%29.jpg"
  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Skyline%2C_Lisbon_%2833807043844%29.jpg/1280px-Skyline%2C_Lisbon_%2833807043844%29.jpg"
  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Portugal%2C_Lisbon_-_skyline_%288588522505%29.jpg/1280px-Portugal%2C_Lisbon_-_skyline_%288588522505%29.jpg"
  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Lisbon_Skyline_from_Miradouro_de_S%C3%A3o_Pedro_de_Alc%C3%A2ntara_at_Twilight_%2854714276547%29.jpg/1280px-Lisbon_Skyline_from_Miradouro_de_S%C3%A3o_Pedro_de_Alc%C3%A2ntara_at_Twilight_%2854714276547%29.jpg"
  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Lisbon_W_Ponte_25_De_Abril_%28256368647%29.jpeg/1280px-Lisbon_W_Ponte_25_De_Abril_%28256368647%29.jpeg"
)

download_all() {
  echo "Downloading Portugal wallpapers..."
  local count=${#WALLPAPERS}
  for i in {1..$count}; do
    local url="${WALLPAPERS[$i]}"
    local filename=$(printf "%s/portugal_%02d.jpg" "$WALLPAPER_DIR" "$i")

    if [[ -f "$filename" ]] && file "$filename" | grep -q "JPEG"; then
      echo "  [$i/$count] Already exists"
      continue
    fi

    printf "  [$i/$count] Downloading... "
    if curl -sL -A "Mozilla/5.0" -o "$filename" "$url" 2>/dev/null; then
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
