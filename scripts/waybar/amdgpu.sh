#!/bin/sh

# outputs GPU info for AMD
# {
#  text: temperature in Celsius,
#  percentage: GPU activity percentage,
#  tooltip: GPU name | GFX version + processes using GPU VRAM,
# }
#
# implemented separately for integrated and discrete GPUs
#
# usage:
# $ bash amdgpu.sh <INT>

processes=$(amdgpu_top -i $1 --single -p | grep "ctx" | awk '{ printf "%5d : %s\n", $7, $1 }' | awk 'NR==1{ printf "%5s   %s\n%s\n", "MB", "PROCESS", $0 } NR>1{ printf "%s\n", $0 }')

if [ $1 -eq 0 ]; then
  # discrete GPU
  amdgpu_top -i $1 --single -d --json |
    jq -c --arg ITEM "$processes" \
      '{
      text: (.[0].gpu_metrics.temperature_hotspot), 
      percentage: (.[0].gpu_activity.GFX.value), 
      tooltip: (.[0].DeviceName + " | " + .[0]."ASIC Name" + "\n\n" + $ITEM),
    }'
else
  # integrated GPU
  amdgpu_top -i $1 --single -d --json |
    jq -c --arg ITEM "$processes" \
      '{
      text: (.[0].gpu_metrics.temperature_soc | round), 
      percentage: (.[0].gpu_activity.GFX.value), 
      tooltip: (.[0].DeviceName + " | " + .[0]."ASIC Name" + "\n\n" + $ITEM),
    }'
fi
