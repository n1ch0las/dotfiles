#!/bin/bash

# Get available updates - checkupdates is part of pacman-contrib
updates=$(checkupdates)

# Check if updates is empty
if [[ -n "$updates" ]]; then
    # Count lines
    count=$(echo "$updates" | wc -l)
    notify-send "$count package(s) can be updated" "$(echo "$updates" | head -n 10)"
fi
