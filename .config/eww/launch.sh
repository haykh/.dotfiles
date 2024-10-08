#!/usr/bin/env bash

CURR_DIR=$(dirname "$0")

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

  # panel_opened=$($EWW active-windows | grep "sidepanel")
  # if [[ $panel_opened != "" ]]; then
  #   $EWW update panelRevealed=true
  # else
  #   $EWW update panelRevealed=false
  # fi

elif [[ $1 == "sidepanel" ]]; then

  $CURR_DIR/scripts/run.sh panels side --toggle >>$CURR_DIR/state/eww.log 2>&1
  $EWW open sidepanel --arg width="$width" --toggle >>$CURR_DIR/state/eww.log 2>&1
  # $EWW open closer-ghost --arg window="floating-panel" --toggle >>~/.config/eww/state/eww.log 2>&1
  $CURR_DIR/scripts/run.sh notifications --update

elif [[ $1 == "hardware-panel" ]]; then

  $CURR_DIR/scripts/run.sh panels hw --toggle >>$CURR_DIR/state/eww.log 2>&1
  $EWW open hardware-panel --arg width="$width" --toggle >>$CURR_DIR/state/eww.log 2>&1
  # $EWW open closer-ghost --arg window="hardware-panel" --toggle >>~/.config/eww/state/eww.log 2>&1

else

  $EWW open $1 --arg width="$width" --toggle

fi
