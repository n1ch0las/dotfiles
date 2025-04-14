#!/bin/bash

MAX=100
SINK="@DEFAULT_SINK@"
STEP=10 # volume step size
SOUND_FILE="$HOME/.volume/blip.mp3"

# Get current volume as a percentage
CURRENT_VOLUME=$(pactl get-sink-volume $SINK | grep -oP '\d+(?=%)' | head -n1)

# Get mute state y/n
IS_MUTED=$(pactl get-sink-mute $SINK | grep -oP '(yes|no)')

# script takes an argument
if [ "$1" == "up" ]; then
    NEW_VOLUME=$((CURRENT_VOLUME + STEP))
    if [ "$NEW_VOLUME" -gt $MAX ]; then
        NEW_VOLUME=$MAX
    fi
elif [ "$1" == "down" ]; then
    NEW_VOLUME=$((CURRENT_VOLUME - STEP))
    if [ "$NEW_VOLUME" -lt 0 ]; then
        NEW_VOLUME=0
    fi
else
    exit 0
fi

# Unmute if necessary
if [ "$IS_MUTED" == "yes" ]; then
   pactl set-sink-mute $SINK 0 
fi

# Apply the new volume level
pactl set-sink-volume $SINK ${NEW_VOLUME}%

# Feedback sound after volume has changed
paplay "$SOUND_FILE"
