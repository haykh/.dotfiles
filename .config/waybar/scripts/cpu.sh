#!/bin/sh

# outputs CPU temp & process info
# {
#  text: average temperature in Celsius,
#  percentage: CPU temperature percentage: 0% = 30C, 100% = 105C,
#  alt: CPU load percentage
# }

# average temperature
TEMP=$(for i in {0..3}; do cat /sys/class/thermal/thermal_zone$i/temp; done | awk '{ print $1 }' | awk '{sum += $1}; END { print sum }')

PCENT=$(((TEMP - 20 * 4000) / (40 * (105 - 20))))

CPU_SUM=$(cat /proc/stat | grep cpu | awk '{usage=($2+$3+$4+$5+$6+$7+$8)} END {print usage}')
CPU_IDLE=$(cat /proc/stat | grep cpu | awk '{usage=$5} END {print usage}')
CPU_SUM_PREV=$(cat /tmp/cpu_sum_prev)
CPU_IDLE_PREV=$(cat /tmp/cpu_idle_prev)

CPU_DELTA=$((CPU_SUM - CPU_SUM_PREV))
CPU_IDLE_DELTA=$((CPU_IDLE - CPU_IDLE_PREV))
CPU_USED=$((CPU_DELTA - CPU_IDLE_DELTA))

LOAD=$((100 * CPU_USED / CPU_DELTA))

echo $CPU_SUM > /tmp/cpu_sum_prev
echo $CPU_IDLE > /tmp/cpu_idle_prev

# PROC=$(ps -eo pcpu,cmd | grep -v '\[' | awk 'NR>2{mem[$2]+=$1}END {for(k in mem) print k " " mem[k]};' | sort -rgk 2 | head -n 10 | awk '{ printf "%5.1f : %s\n", $2, $1 };' | awk 'NR==1{ printf "%5s   %s\\n%s\\n", "CPU%", "PROCESS", $0 } NR>1{ printf "%s\\n", $0 }')

jq -n -c --arg TEMP "$TEMP" --arg PCENT "$PCENT" --arg LOAD "$LOAD" \
   '{
      text: ($TEMP|tonumber / 4000) | round, 
      percentage: $PCENT, 
      alt: $LOAD 
    }'
