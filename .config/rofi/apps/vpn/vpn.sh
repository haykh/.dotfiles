#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f /tmp/vpn ]; then
  vpnrunning=$(cat /tmp/vpn)
else
  vpnrunning="N"
fi

pick=$(RUNNING=$vpnrunning $SCRIPT_DIR/parser.sh | rofi -dmenu -i -p "VPN" -no-fixed-num-lines -theme-str "@import \"$SCRIPT_DIR/vpn.rasi\"")

if [ -z "$pick" ]; then
  exit 1
fi

if [ "$pick" == "DISCONNECT" ]; then
  pkexec wg-quick down $HOME/.config/vpn/protonvpn-$(cat /tmp/vpn | tr '[:upper:]' '[:lower:]').conf && rm /tmp/vpn
else
  shortpick=$(echo "$pick" | awk '{print $1}')
  lowershortpick=$(echo "$shortpick" | tr '[:upper:]' '[:lower:]')
  vpnconf=$HOME/.config/vpn/protonvpn-$(echo $lowershortpick).conf
  if [ -f /tmp/vpn ]; then
    pkexec sh -c "wg-quick down $HOME/.config/vpn/protonvpn-$(cat /tmp/vpn | tr '[:upper:]' '[:lower:]').conf &&
      wg-quick up $vpnconf" && (echo $shortpick >/tmp/vpn)
  else
    pkexec wg-quick up $vpnconf &&
      (echo $shortpick >/tmp/vpn)
  fi
fi
