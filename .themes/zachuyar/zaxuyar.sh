#!/bin/bash
. ./shaitan.sh

white="#FFFFFF"
black="#000000"

colors=(
  "#2455B7"
  "#F561EB"
  "#7FDEFF"
  "#F61E33"
  "#F8C630"
)

# colors=(
#   "#2455B7"
#   "#f561eb"
#   "#7FDEFF"
#   "#F61E33"
#   "#F8C630"
# )

declare -A shades

for i in $(seq 0 $((${#colors[@]} - 1))); do
  color=${colors[$i]}
  shades[${i}]="$(darken $(desaturate $color 20) 80)
                $(darken $(desaturate $color 20) 60)
                $(darken $(desaturate $color 20) 40)
                $(darken $(desaturate $color 10) 20)
                $color 
                $(desaturate $(lighten $color 10) 20) 
                $(desaturate $(lighten $color 20) 20) 
                $(desaturate $(lighten $color 30) 20) 
                $(desaturate $(lighten $color 40) 20)"
done

shade() {
  echo ${shades[${1}]}
}

brightness() {
  # split $1 with delim ' '
  local -a colors=($1)
}

# ---- kitty ----

declare -A kitty_map
map["bg_main"]=$(brightness "${shades[0]}" 3)

echo ${map["bg_main"]}
