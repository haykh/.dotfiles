#!/usr/bin/env bash

function code2flag() {
  i=$(echo $1 | tr '[:lower:]' '[:upper:]')
  echo -e $(printf '\\U%X\\U%X' $(($(printf '%d' "'${i:0:1}") + 127397)) $(($(printf '%d' "'${i:1}") + 127397)))
}

connected="N"
for i in $(ls $HOME/.config/vpn/ | sed 's/\.conf$//' | sed 's/^protonvpn-//'); do
  flag=$(code2flag $i)
  i=$(echo $i | tr '[:lower:]' '[:upper:]')
  if [ $RUNNING != "N" ] && [ $RUNNING == $i ]; then
    echo -e "$i $flag "
    connected="Y"
  else
    echo -e "$i $flag"
  fi
done

if [ "$connected" == "Y" ]; then
  echo -e "DISCONNECT"
fi
