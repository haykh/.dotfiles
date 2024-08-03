#!/usr/bin/env bash

jq -r 'to_entries | map("\(.key) \(.value | tostring)") | .[]' icons.json |
  awk '{ printf "%s\0icon\x1f<span color=\"white\">%c</span>\n", $1, strtonum("0x" $2)}' |
  rofi -dmenu \
    -show-icons \
    -theme-str '
  prompt {
    str: "λ";
  }
  entry {
    placeholder: "search nerdicons";
  }
  listview {
    require-input: true;
  }' |
  xargs -I % jq -r '.["%"] | (. | tostring)' icons.json |
  awk '{ printf "%c", strtonum("0x" $1) }' |
  wl-copy
