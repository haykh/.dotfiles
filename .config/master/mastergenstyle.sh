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
    "$font-alt: \(.fonts.alt);\n" +
    "$font-mono: \(.fonts.mono);\n" +
    "$font-serif: \(.fonts.serif);\n\n" +
    (.colors | (
      "$col-bg: \(.theme.bg);\n" + 
      "$col-bg-alt: \(.theme."bg-alt");\n" + 
      "$col-border: \(.theme.border);\n" + 
      "$col-fg: \(.theme.fg);\n" + 
      "$col-fg-dim: \(.theme."fg-dim");\n" + 
      "$col-accent1: \(.theme.accent1);\n" + 
      "$col-accent2: \(.theme.accent2);\n" + 
      "$col-accent3: \(.theme.accent3);\n" + 
      "$col-accent4: \(.theme.accent4);\n\n" + 
      "$col-heat-0: \(.heat[0]);\n" + 
      "$col-heat-1: \(.heat[1]);\n" + 
      "$col-heat-2: \(.heat[2]);\n" + 
      "$col-heat-3: \(.heat[3]);\n" + 
      "$col-heat-4: \(.heat[4]);\n" + 
      "$col-heat-5: \(.heat[5]);\n\n" + 
      "$col-battery-1: \(.charge[0]);\n" + 
      "$col-battery-2: \(.charge[1]);\n" + 
      "$col-battery-3: \(.charge[2]);\n" + 
      "$col-battery-4: \(.charge[3]);\n" + 
      "$col-battery-5: \(.charge[4]);\n" + 
      "$col-battery-6: \(.charge[5]);\n\n" + 
      "$col-performance: \(.sequential[2]);\n" + 
      "$col-balanced: \(.sequential[1]);\n" + 
      "$col-power-saver: \(.sequential[0]);\n\n" + 
      "$col-device-disconnected: \(.status.disabled);\n" + 
      "$col-device-off: \(.status.inactive);\n\n" +
      "$col-humidity-1: \(.wet[0]);\n" +
      "$col-humidity-2: \(.wet[1]);\n" +
      "$col-humidity-3: \(.wet[2]);\n" +
      "$col-humidity-4: \(.wet[3]);\n" +
      "$col-humidity-5: \(.wet[4]);\n" +
      "$col-humidity-6: \(.wet[5]);\n" +
      "$col-humidity-7: \(.wet[6]);\n\n" +
      "$col-pressure-1: \(.coolwarm[0]);\n" +
      "$col-pressure-2: \(.coolwarm[1]);\n" +
      "$col-pressure-3: \(.coolwarm[2]);\n" +
      "$col-pressure-4: \(.coolwarm[3]);\n" +
      "$col-pressure-5: \(.coolwarm[4]);\n\n" +
      "$col-uvindex-1: \(.heat[0]);\n" +
      "$col-uvindex-2: \(.heat[1]);\n" +
      "$col-uvindex-3: \(.heat[2]);\n" +
      "$col-uvindex-4: \(.heat[3]);\n" +
      "$col-uvindex-5: \(.heat[4]);\n" +
      "$col-uvindex-6: \(.heat[5]);\n\n" +
      "$col-category-1: \(.sequential[2]);\n" +
      "$col-category-2: \(.sequential[1]);\n" +
      "$col-category-3: \(.sequential[0]);\n\n" +
      "$col-applauncher: \(.special.applauncher);\n"
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
