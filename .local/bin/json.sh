#!/usr/bin/env sh

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Parse Clipboard as JSON
# @raycast.mode silent


pbpaste | json5 | pbcopy
open "raycast://extensions/vladimir-kotikov/raycast-jq/run-query"
