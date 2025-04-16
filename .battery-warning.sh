#!/bin/bash

THRESHOLD=15

BATTERY=$(cat /sys/class/power_supply/BAT1/capacity)
STATE=$(cat /sys/class/power_supply/BAT1/status)

if [[ "$STATE" == "Discharging" && "$BATTERY" -lt "$THRESHOLD" ]]; then
  notify-send -u critical "Low Battery" "Battery level is at ${BATTERY}%"
fi
