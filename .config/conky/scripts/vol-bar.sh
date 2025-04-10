#!/bin/bash

SINK=$(pactl get-default-sink)
pactl get-sink-volume "$SINK" | awk -F'/' '/front-left:/ {gsub(/%/, "", $2); print $2}' | tr -d ' '
