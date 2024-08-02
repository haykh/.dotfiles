#!/bin/sh

not_daemon() {
  if command -v dunstify &>/dev/null; then
    dunstify "$@"
  else
    notify-send "$@"
  fi
}

switch() {
  hyprctl switchxkblayout $(
    hyprctl devices -j |
      jq -r '.keyboards | map(select(.main == true)) | .[].name'
  ) next
}

notify() {
  local layout=$(
    hyprctl devices -j |
      jq -r '.keyboards | map(select(.main == true)) | .[].active_keymap'
  )
  if [[ $layout == *"English"* ]]; then
    icon="🇺🇸"
  else
    icon="🇷🇺"
  fi
  not_daemon \
    -a kblayout-control -u low \
    -i "EMPTY" \
    -h string:x-canonical-private-synchronous:sys-notify \
    "$icon $layout"
}

if [[ $1 == "--show" ]]; then
  notify
else
  switch && notify
fi
