#!/usr/bin/env bash

EWWBIN="$HOME/.local/eww.app/target/release/eww"
EWW="$EWWBIN -c $HOME/.config/eww --force-wayland"

monitor_scale="$(hyprctl -j monitors | jq -r '
  first(.[] | select(.focused)) | 
    (.model + "\n" + (.width | tostring) + "\n" + (.scale | tostring))
')"
monitor=$(echo "$monitor_scale" | head -n 1)
width=$(echo "$monitor_scale" | head -n 2 | tail -n 1)
scale=$(echo "$monitor_scale" | tail -n 1)
width=$(echo "scale=1; $width / $scale - 10" | bc)

if [[ $1 == "mainbar" ]]; then

  $EWWBIN kill
  killall eww
  pkill eww

  $EWW open mainbar --arg screen="$monitor" --arg width="$width" &

else

  $EWW open $1 --arg width="$width" --toggle

fi
