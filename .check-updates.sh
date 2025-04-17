#!/bin/bash

# Get available updates - checkupdates is part of pacman-contrib
updates=$(checkupdates)

# Count lines
count=$(echo "$updates" | wc -l)

if (( count > 0 )); then
    notify-send "$count package(s) can be updated" "$(echo "$updates" | head -n 10)"
fi
