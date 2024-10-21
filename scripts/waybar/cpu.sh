#!/bin/sh

# outputs CPU temp & process info
# {
#  text: average temperature in Celsius,
#  percentage: CPU temperature percentage: 0% = 30C, 100% = 105C,
#  alt: CPU load percentage,
#  tooltip: top 10 processes using CPU,
# }

TEMP=$(for i in {0..3}; do cat /sys/class/thermal/thermal_zone$i/temp; done | sort | tail -n 1)

PCENT=$(((TEMP - 20000) / (10 * (105 - 20))))

LOAD=$(ps -eo pcpu | awk 'NR>1{sum += $0} END {printf "%.0f", sum / 8}')

PROC=$(ps -eo pcpu,cmd | grep -v '\[' | awk 'NR>2{mem[$2]+=$1}END {for(k in mem) print k " " mem[k]};' | sort -rgk 2 | head -n 10 | awk '{ printf "%5.1f : %s\n", $2, $1 };' | awk 'NR==1{ printf "%5s   %s\n%s\n", "CPU%", "PROCESS", $0 } NR>1{ printf "%s\n", $0 }')

jq -n -c --arg TEMP "$TEMP" --arg PCENT "$PCENT" --arg LOAD "$LOAD" --arg PROC "$PROC" \
  '{
      text: ($TEMP|tonumber / 1000) | round, 
      percentage: ($PCENT | tonumber), 
      alt: $LOAD,
      tooltip: $PROC
    }'
