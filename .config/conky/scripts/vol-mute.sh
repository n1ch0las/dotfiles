#!/bin/bash
SINK=$(pactl get-default-sink)
pactl get-sink-mute "$SINK" | awk '{print ($2 == "yes") ? 1 : 0}'
