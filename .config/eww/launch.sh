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

  $EWWBIN active-windows | awk -F: '{print $1}' | xargs -I {} $EWWBIN close {}
  $EWWBIN kill
  killall eww
  pkill eww

  $EWW open mainbar --arg screen="$monitor" --arg width="$width" &
  echo "false" >$CURR_DIR/state/hw-panel
  echo "false" >$CURR_DIR/state/sidepanel

  sleep 1

  persistent=("cpuShowT" "cpuShowUsage" "ramShowGB" "ramShowUsage" "gpu0ShowT" "gpu0ShowUsage" "gpu1ShowT" "gpu1ShowUsage")

  for i in "${persistent[@]}"; do
    if [[ -f $CURR_DIR/state/$i ]]; then
      echo $i : $(cat $CURR_DIR/state/$i) >>$CURR_DIR/state/eww.log
      $EWWBIN update $i=$(tail -n1 $CURR_DIR/state/$i)
    fi
  done

elif [[ $1 == "sidepanel" ]]; then

  $CURR_DIR/scripts/run.sh panels side --toggle >>$CURR_DIR/state/eww.log 2>&1
  $EWW open --id sidepanel sidepanel --arg width="$width" --toggle >>$CURR_DIR/state/eww.log 2>&1
  # $EWW open closer-ghost --arg window="floating-panel" --toggle >>~/.config/eww/state/eww.log 2>&1
  $CURR_DIR/scripts/run.sh notifications --update

elif [[ $1 == "hardware-panel" ]]; then

  $CURR_DIR/scripts/run.sh panels hw --toggle >>$CURR_DIR/state/eww.log 2>&1
  $EWW open hardware-panel --arg width="$width" --toggle >>$CURR_DIR/state/eww.log 2>&1
  # $EWW open closer-ghost --arg window="hardware-panel" --toggle >>~/.config/eww/state/eww.log 2>&1

elif [[ $1 == "update" ]]; then

  $EWWBIN update $2=$3
  echo $3 >$CURR_DIR/state/$2

else

  $EWW open $1 --arg width="$width" --toggle

fi
