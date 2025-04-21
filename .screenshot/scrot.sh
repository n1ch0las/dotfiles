#!/bin/bash

# Output directory and filename
dir=~/Pictures/Screenshots
file="$dir/screenshot_$(date +%F_%H:%M:%S).png"

# Display name (from xrandr)
display="eDP-1"

# Argument passed to the script
mode=$1

# Scrot status
success=false

# Take screenshot based on the mode argument
case $mode in
  "window")
    if scrot --focused --border "$file"; then
        success=true
    fi
    ;;
  "selection")
    # Screenshot of selected region, uses maim because it plays
    # nice with Picom
    if maim -s "$file"; then
        success=true
    fi
    ;;
  *)
    # default to fullscreen shot
    if scrot "$file"; then
        success=true
    fi
    ;;
esac

# Only do flash and shutter sound if screenshot succeeded
if [ "$success" = true ]; then
    # Flash
    xrandr --output "$display" --brightness 0.1
    sleep 0.1
    xrandr --output "$display" --brightness 1.0

    # Shutter sound
    paplay ~/.screenshot/shutter.mp3
fi

