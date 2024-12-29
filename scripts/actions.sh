#!/usr/bin/env bash

if [[ $1 == '--enlarge' ]]; then
  wmctrl -r :ACTIVE: -e 0,$(wmctrl -d | awk '{ if($2 == "*") print $4 }' | xargs | sed 's/x/ /g' | awk '{ print (0.1 * $1) "," (0.1 * $2) "," (0.8 * $1) "," (0.8 * $2) }')
elif [[ $1 == '--pick-color' ]]; then
  GTK_THEME="Fluent:dark" gpick
fi
