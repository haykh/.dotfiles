#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

icon=$(
  jq -r 'to_entries | map("\(.key) \(.value | tostring)") | .[]' $SCRIPT_DIR/icons.json |
    awk '{ 
    sub(/^nf-/, "", $1); 
    if ($1 != "lentach") 
      printf "%s\0icon\x1f<span color=\"#9cb9dd\" font=\"MonaspiceKr Nerd Font\">%c </span>\n", \
        $1, \
        strtonum("0x" $2)
    else
      printf "%s\0icon\x1f<span color=\"#9cb9dd\" font=\"MonaspiceKr Nerd Font\">%s </span>\n", \
        $1, \
        $2
    }' |
    rofi -dmenu \
      -show-icons \
      -kb-row-left Left -kb-row-right Right \
      -kb-move-char-back Control+b -kb-move-char-forward Control+f \
      -theme-str "@import \"$SCRIPT_DIR/nerdicons.rasi\"" |
    xargs -I % jq -r '.["nf-%"] | (("%" | tostring) + " " + (. | tostring))' $SCRIPT_DIR/icons.json |
    awk '{ 
      if ($1 != "lentach")
        printf "%c", strtonum("0x" $2)
      else
        printf "%s", $2
    }'
)

if [[ $XDG_SESSION_TYPE == x11 ]]; then
  echo $icon | xclip -selection clipboard
else
  (wl-copy $icon) && wtype $icon
fi
