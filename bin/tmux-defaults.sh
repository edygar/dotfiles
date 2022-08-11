#!/usr/bin/env bash
export FZF_LAYOUT="
--layout=reverse
--no-info
--keep-right
--color='fg:#abb2bf,bg:#1b1f27,gutter:#1C2026,preview-bg:#1C2026,pointer:#44A5F9,bg+:#042E48,fg+:#abb2bf,hl:#d5b06b,hl+:#d5b06b'
--preview-window='right,75%,border-rounded'
--prompt=' '
--pointer=' '
"
export FZF_DEFAULT_OPTS="$FZF_LAYOUT"
