#!/bin/bash

# Output directory and filename
dir=~/Pictures/Screenshots
file="$dir/scrot_$(date +%F_%H:%M:%S).png"

# Display name (from xrandr)
display="eDP-1"

# Take screenshot based on mode argument
mode=$1
case $mode in
  "window")
    scrot --focused --border "$file"
    ;;
  "selection")
    scrot --select "$file"
    ;;
  *)
    # default to fullscreen shot
    scrot "$file"
    ;;
esac

# Flash
xrandr --output "$display" --brightness 0.1
sleep 0.1
xrandr --output "$display" --brightness 1.0

# Shutter sound
paplay ~/.screenshot/shutter.mp3

