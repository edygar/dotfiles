#!/usr/bin/env bash
export FZF_LAYOUT="
--layout=reverse
--inline-info
--prompt=' '
--keep-right
--color='fg:#abb2bf,gutter:#1C2026,pointer:#44A5F9,fg+:#abb2bf,hl:#d5b06b,hl+:#d5b06b'
--color='prompt:#61afef,header:#566370,info:#5c6370,gutter:#1C2026'
--preview-window='right,75%,border-rounded'
--bind=alt-v:toggle-preview,alt-j:preview-down,alt-k:preview-up
--bind=alt-d:preview-half-page-down,alt-u:preview-half-page-up
--bind=ctrl-space:toggle+up,ctrl-d:half-page-down,ctrl-u:half-page-up
--pointer=' '
"
export FZF_DEFAULT_OPTS="$FZF_LAYOUT"
