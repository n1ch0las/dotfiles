#!/bin/bash

# Output directory and filename
dir=~/Pictures/Screenshots
file="$dir/scrot_$(date +%F_%H:%M:%S).png"

# Display name (from xrandr)
display="eDP-1"

# Argument passed to the script
mode=$1

# Take screenshot based on the mode argument
case $mode in
  "window")
    scrot --focused --border "$file"
    ;;
  "selection")
    # Kill picom if running as it interferes with selection
    if pgrep -x "picom" > /dev/null; then
        killall picom
        picom_was_running=true
    else
        picom_was_running=false
    fi

    # Screenshot of selected region
    scrot --select "$file"
    
    # Restart picom if necessary
    if [ "$picom_was_running" = true ]; then
        picom &
    fi
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

