#!/usr/bin/env zsh
tab_title="nvim(.dotfiles)";
id=$(kitty @ ls | jq ".[] | select(.is_active == true)| .tabs[] | select(.title == \"$tab_title\") | .id")

if [[ -z "$id" ]];
then
  kitty @ launch --type tab --tab-title $tab_title --cwd="$HOME/.dotfiles" nvim -c "lua require('persistence').load({ last = true })"
else
  kitty @ focus-tab --match id:"$id"
  exit 0;
fi
