#!/bin/bash

#awk '{printf "%.1f°C", $1 / 1000}' /sys/class/thermal/thermal_zone4/temp
awk '{printf "%.1fC", $1 / 1000}' /sys/class/thermal/thermal_zone4/temp
