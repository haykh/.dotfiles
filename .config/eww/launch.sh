#!/usr/bin/env bash

EWWBIN="$HOME/.local/eww.app/target/release/eww"
EWW="$EWWBIN -c $HOME/.config/eww --force-wayland"

if [[ $1 == "mainbar" ]]; then
  monitor_scale="$(hyprctl -j monitors | jq -r '
    first(.[] | select(.focused)) | 
      (.model + "\n" + (.width | tostring) + "\n" + (.scale | tostring))
  ')"
  monitor=$(echo "$monitor_scale" | head -n 1)
  width=$(echo "$monitor_scale" | head -n 2 | tail -n 1)
  scale=$(echo "$monitor_scale" | tail -n 1)
  width=$(echo "scale=1; $width / $scale - 10" | bc)
  # if [[ ! $(pidof eww) ]]; then
  #   ${EWW} daemon
  #   sleep 1
  # fi
  $EWWBIN kill && killall eww && pkill eww
  $EWW open mainbar --arg screen="$monitor" --arg width="$width""px" &
else
  $EWW open $1 --toggle
fi
