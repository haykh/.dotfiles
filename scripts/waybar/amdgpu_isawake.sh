#!/bin/sh

# check if GPU is awake
# return code 0 if awake, 1 if asleep
#
# usage:
# $ bash amdgpu_isawake.sh <INT>

# map device ID to hwmon
if [ $1 -eq 0 ]; then
  HWMON=4
else
  HWMON=5
fi

POWER=$(cat /sys/class/hwmon/hwmon${HWMON}/device/power_state)

if [ "$POWER" == "D0" ]; then
  exit 0
else
  exit 1
fi
