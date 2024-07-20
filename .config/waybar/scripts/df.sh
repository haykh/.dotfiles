#!/bin/sh

# outputs root and home partition disk usage
# {
#  text: root usage percentage,
#  alt: home usage percentage,
#  tooltip: root and home usage report,
# }

ROOT_USG=$(df -h | awk 'NR>1{ if ($6 == "/") {print $5} }')
HOME_USG=$(df -h | awk 'NR>1{ if ($6 == "/home") {print $5} }')

TOOLTIP=$(df -h | awk 'NR>1{ if ($6 == "/" || $6 == "/home") {printf "%5s free @ %-6s (tot: %s, used: %s)\n", $4, $6, $2, $5} }')

jq -n -c --arg ROOT_USG "$ROOT_USG" --arg HOME_USG "$HOME_USG" --arg TOOLTIP "$TOOLTIP" \
   '{
      text: $ROOT_USG, 
      alt: $HOME_USG, 
      tooltip: $TOOLTIP 
    }'
