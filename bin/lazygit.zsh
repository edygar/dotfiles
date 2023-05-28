#!/usr/bin/env zsh
tab_title="LazyGit($(basename $(pwd)))";

id=$(kitty @ ls | jq ".[] | select(.is_active == true)| .tabs[] | select(.title == \"$tab_title\") | .id")

if [[ -z "$id" ]];
then
  kitty @ launch --type tab --tab-title $tab_title --cwd current zsh -c ". ~/.zprofile; lazygit"
else
  kitty @ focus-tab --match id:"$id"
  exit 0;
fi
