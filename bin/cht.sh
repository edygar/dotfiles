#!/usr/bin/env bash
selected=$(curl -s "http://cht.sh/:list$lookup" | fzf)
read -p "Query: " query

curl "cht.sh/$selected $query" | less
