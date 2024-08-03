#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

jq -r 'to_entries | map("\(.key) \(.value | tostring)") | .[]' $SCRIPT_DIR/icons.json |
  awk '{ 
    sub(/^nf-/, "", $1); 
    printf "%s\0icon\x1f<span color=\"#9cb9dd\" font=\"MonaspiceKr Nerd Font\">%c </span>\n", \
      $1, \
      strtonum("0x" $2)
    }' |
  rofi -dmenu \
    -show-icons \
    -kb-row-left Left -kb-row-right Right \
    -kb-move-char-back Control+b -kb-move-char-forward Control+f \
    -theme-str '@import "~/.config/rofi/nerdicons.rasi"' |
  xargs -I % jq -r '.["%"] | (. | tostring)' $SCRIPT_DIR/icons.json |
  awk '{ printf "%c", strtonum("0x" $1) }' |
  wl-copy
