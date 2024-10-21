#!/bin/sh

# outputs memory info
# {
#  text: memory usage in GB,
#  percentage: memory usage percentage,
#  tooltip: top 10 processes using memory,
# }

PROC=$(ps -eo rss,cmd | grep -v '\[' | awk '
  NR>2 {
    mem[$2]+=$1
  } END {
    for(k in mem) 
      print k " " mem[k]/1024
  };' | sort -rgk 2 | head -n 10 | awk '
  { 
    printf "%5.0f : %s\n", $2, $1 
  };' | awk '
  NR==1 { 
    printf "%5s   %s\n%s\n", "MB", "PROCESS", $0 
  } NR>1 { 
    printf "%s\n", $0 
  }' | sed 's/\n$//')

USAGE=$(free -m | grep Mem | awk '{printf "%.1f", $3 / 1024}')
PCENT=$(free -m | grep Mem | awk '{printf "%.1f", ($3 / $2) * 100}')

jq -n -c --arg USAGE "$USAGE" --arg PCENT $PCENT --arg PROC "$PROC" \
   '{
      text: $USAGE,
      percentage: ($PCENT | tonumber), 
      tooltip: $PROC
    }'
