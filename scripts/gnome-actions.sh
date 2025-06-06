#!/usr/bin/env bash

function enlarge() {
  window=$1
  wmctrl -r "${window}" -e 0,"$(
    wmctrl -d |
      awk '{ if($2 == "*") print $4 }' |
      xargs | sed 's/x/ /g' |
      awk '{ print (0.1 * $1) "," (0.1 * $2) "," (0.8 * $1) "," (0.8 * $2) }'
  )"
}

if [[ $1 == '--enlarge' ]]; then

  enlarge :ACTIVE:

elif [[ $1 == '--close' ]]; then

  wmctrl -c :ACTIVE:

elif [[ $1 == '--open' ]]; then

  cmd=""
  class=""

  if [[ $2 == 'slack' ]]; then
    cmd="slack"
    class=" - Slack"
  elif [[ $2 == "email" ]]; then
    cmd="thunderbird"
    class=" - Mozilla Thunderbird"
  fi
  if [[ -n $cmd ]]; then
    if [[ -z $(pgrep $cmd) ]]; then
      $cmd >/dev/null 2>&1 &
    elif ! (wmctrl -l | grep -q "$class"); then
      $cmd >/dev/null 2>&1 && wmctrl -R "$class" &
    else
      wmctrl -R "$class" &
    fi
  fi

elif [[ $1 == '--screenshot' ]]; then

  if [[ $2 == 'select' ]]; then
    flameshot gui -s -c >/dev/null 2>&1 &
  elif [[ $2 == 'gui' ]]; then
    flameshot gui >/dev/null 2>&1 &
  elif [[ $2 == 'full' ]]; then
    flameshot screen -c >/dev/null 2>&1 &
  fi

elif [[ $1 == '--pick-color' ]]; then

  GTK_THEME="Fluent:dark" gpick

fi
