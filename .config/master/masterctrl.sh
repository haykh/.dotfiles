#!/usr/bin/env bash

SCRIPT_DIR=$HOME/.config/master/scripts
ROFI_DIR=$HOME/.config/rofi

LOGFILE=$TMPDIR/masterctrl.log

# dependencies:
# - jq, grep, awk, bc, sort, head, sed, ps, cat, socat, tr
# - dunst [optional]
# - alacritty
# - hyprland
# - pamixer
# - brightnessctl
# - bluetoothctl
# - bluetui
# - nmtui
# - nmcli
# - ifstat
# - amdgpu_top
# - pulsemixer
# - powerprofilesctl

help() {
  echo "Usage: ./masterctrl.sh [option] [args]"
  echo ""
  echo "Options:"
  echo ""
  echo "  > help : show this help message"
  echo ""
  echo "  > volume (1) (2) (3*)"
  echo "    (1) [ --speaker | --mic ] : select the device to control"
  echo "    (2) [ --inc <n> | --dec <n> ] : increase or decrease the volume by <n> %"
  echo "    (2) --toggle : mutes or unmutes the volume"
  echo "    (2) --get : returns the current volume"
  echo "    (2) --open : open the volume manager"
  echo "    (3*) --nonotify : don't show a notification [optional]"
  echo ""
  echo "  > notifications (1)"
  echo "  --clear <id>: clear notifications by id"
  echo "  --clearall: clear all notifications"
  echo "  --update: update notifications"
  echo ""
  echo "  > brightness (1) (2*)"
  echo "    (1) [ --inc <n> | --dec <n> ] : increase or decrease the brightness by <n> %"
  echo "    (1) --get : returns the current brightness"
  echo "    (1) --show : true if laptop screen is used"
  echo "    (2*) --nonotify : don't show a notification [optional]"
  echo ""
  echo "  > workspaces (1)"
  echo "    (1) [ --next| --prev] : switch to the next or previous workspace"
  echo "    (1) --listen : start daemon for workspace changes"
  echo "    (1) --eww : returns a literal for eww"
  echo ""
  echo "  > tray (1)"
  echo "    (1) --eww : update tray widgets"
  echo "    (1) --getactive : get active window id"
  echo "    (1) --minimize <id> : minimize window with id to tray"
  echo "    (1) --restore <id> : restore window with id"
  echo "    (1) --minimize_active : minimize active window to tray"
  echo "    (1) --restore_last : restore last minimized window"
  echo ""
  echo "  > player (1)"
  echo "    (1) --play-pause : play or pause the media"
  echo "    (1) [ --next | --prev ] : play the next or previous media"
  echo "    (1) --update : update the metadata"
  echo "    (1) --tick : update the time in eww"
  echo ""
  echo "  > monitor (1)"
  echo "    (1) [ on | off ] : switch laptop display on or off"
  echo ""
  echo "  > bluetooth (1)"
  echo "    (1) --power-toggle : toggle the bluetooth power state"
  echo "    (1) --open : open the bluetooth manager"
  echo "    (1) --info : returns a json with {state, devices, icon}"
  echo ""
  echo "  > wifi (1)"
  echo "    (1) --power-toggle : toggle the wifi power state"
  echo "    (1) --open : open the wifi manager"
  echo "    (1) --info : returns a json with {state, ssid, icon}"
  echo "    (1) --usage : returns download/upload usage in *B/s"
  echo "    (1) --address : returns local and global ip address"
  echo ""
  echo "  > amdgpu (1) (2)"
  echo "    (1) [ 0 | 1 ] : select the gpu to display (0: dedicated, 1: integrated)"
  echo "    (2) --info : returns a json with {temp, percentage}"
  echo "    (2) --isawake : 1 if the gpu is awake, 0 otherwise"
  echo "    (2) --procs : returns processes using the gpu"
  echo ""
  echo "  > ram (1)"
  echo "    (1) --procs : returns processes using the most ram"
  echo ""
  echo "  > cpu (1)"
  echo "    (1) --procs : returns processes using the most cpu"
  echo ""
  echo "  > power (1)"
  echo "    (1) --info : json info {status, icon, pcent, pcent_state, tooltip, mode, modeicon}"
  echo "    (1) --nextmode : next power mode"
  echo ""
  echo "  > weather (1)"
  echo "    (1) --listen : start weather daemon"
  echo ""
  echo "  > panels (1) (2)"
  echo "    (1) [hw | side] : which panel to pick"
  echo "    (2) --toggle : toggle the panel"
  echo "    (2) --state : returns the state of the panel"
  echo ""
}

if [[ $1 == "help" ]]; then
  help
elif [[ $1 == "rofi" ]]; then
  $ROFI_DIR/apps/launch $2
elif [[ -f $SCRIPT_DIR/$1 ]]; then
  $SCRIPT_DIR/$1 "${@:2}"
else
  echo "Invalid option $1" >>$LOGFILE
  help
  exit 1
fi
