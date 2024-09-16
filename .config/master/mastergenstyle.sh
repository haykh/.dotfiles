#!/usr/bin/env bash

MASTERCFG=$(dirname $0)/mastercfg.json

if [ ! -f $MASTERCFG ]; then

  echo "mastercfg.json not found"
  exit 1

else

  # eww style
  ewwfile=$HOME/.config/eww/style.scss
  jq -r '
    "$font-main: \(.fonts.main);\n" +
    "$font-alt: \(.fonts.alt);\n\n" +
    (.colors | (
      "$col-bg: \(.theme.bg);\n" + 
      "$col-bg-alt: \(.theme."bg-alt");\n" + 
      "$col-border: \(.theme.border);\n" + 
      "$col-fg: \(.theme.fg);\n" + 
      "$col-fg-dim: \(.theme."fg-dim");\n" + 
      "$col-accent: \(.theme.accent);\n" + 
      "$col-accent-alt: \(.theme."accent-alt");\n" + 
      "$col-heat-0: \(.temperature[0]);\n" + 
      "$col-heat-1: \(.temperature[1]);\n" + 
      "$col-heat-2: \(.temperature[2]);\n" + 
      "$col-heat-3: \(.temperature[3]);\n" + 
      "$col-heat-4: \(.temperature[4]);\n" + 
      "$col-heat-5: \(.temperature[5]);\n" + 
      "$col-battery-1: \(.charge[0]);\n" + 
      "$col-battery-2: \(.charge[1]);\n" + 
      "$col-battery-3: \(.charge[2]);\n" + 
      "$col-battery-4: \(.charge[3]);\n" + 
      "$col-battery-5: \(.charge[4]);\n" + 
      "$col-battery-6: \(.charge[5]);\n" + 
      "$col-performance: \(.sequential[2]);\n" + 
      "$col-balanced: \(.sequential[1]);\n" + 
      "$col-power-saver: \(.sequential[0]);\n" + 
      "$col-device-disconnected: \(.status.disabled);\n" + 
      "$col-device-off: \(.status.inactive);\n"
      )
    )' $MASTERCFG >$ewwfile

fi

# generate rofi config

# generate dunstrc
#
# "
# [global]
#   background = "#..."
#   foreground = "#..."
#   highlight = "#..."
#
#   font = ..., ... 11
#
#   corner_radius = ...
#
# [urgency_low]
#   frame_color = "#..."
#   foreground="#..."
#
# [urgency_normal]
#   frame_color = "#..."
#   foreground="#..."
#
# [urgency_critical]
#   frame_color = "#..."
#   foreground="#..."
# "
