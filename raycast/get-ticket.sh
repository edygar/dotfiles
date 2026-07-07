#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Get Ticket
# @raycast.mode compact
# @raycast.packageName Jira
# @raycast.description Extract the first JIRA ticket key from selection/clipboard and copy it.
# @raycast.author You
# @raycast.argument1 { "type": "text", "placeholder": "Selection (optional)", "optional": true }
# @raycast.argument2 { "type": "text", "placeholder": "Clipboard (optional)", "optional": true }

set -euo pipefail

selection="${1:-}"
clip_arg="${2:-}"

input=""

# Prefer selection
if [[ -n "${selection//[[:space:]]/}" ]]; then
  input="$selection"
# Then explicit clipboard arg (if you pass it)
elif [[ -n "${clip_arg//[[:space:]]/}" ]]; then
  input="$clip_arg"
# Finally, read actual clipboard
else
  input="$(pbpaste || true)"
fi

ticket="$(
  printf "%s" "$input" \
    | LC_ALL=C grep -Eo '[A-Z][A-Z0-9]+-[0-9]+' \
    | head -n 1 \
    || true
)"

if [[ -z "$ticket" ]]; then
  echo "No ticket found for input $input"
  exit 1
fi

echo "$ticket"
printf "%s" "$ticket" | pbcopy
