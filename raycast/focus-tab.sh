#!/usr/bin/env sh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Focus tab
# @raycast.mode silent
# @raycast.argument1 { "type": "text", "placeholder": "Url", "required": true }
# @raycast.argument2 { "type": "dropdown", "placeholder": "Fuzzy", "required": false, "data": [ { "title": "yes", "value": "yes" }, { "title": "no", "value": "no" } ] }
PATH="$PATH:$HOME/.dotfiles/bin"

url="$1"
fuzzy="$2"

if [ "$fuzzy" = "yes" ]; then
  matcher="contains"
else
  matcher="startswith"
fi

tab=$(list-tabs.js "Google Chrome" | jq -r '.items[] | select(.url | '$matcher'("'$url'")) | .arg')

if [ -z "$tab" ]; then
  if [ "$fuzzy" = "yes" ]; then
    echo 'No tabs found for "'$url'"'
    exit 0
  fi
  open $url
  echo $tab
else
  browser="Google Chrome" focus-tab.js "$tab"
fi

