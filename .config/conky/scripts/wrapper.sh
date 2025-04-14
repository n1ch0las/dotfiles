#!/bin/bash

# Define the path to the config
CONFIG_PATH="$HOME/.config/conky/$1.conf"

# Check for a running conky process with this config
CONKY_PID=$(pgrep -f "conky -c $CONFIG_PATH")

if [ -n "$CONKY_PID" ]; then
  # Kill it
  kill "$CONKY_PID"
else
  # Launch conky
  conky -c "$CONFIG_PATH" -D && xdotool search --sync --classname "conky" windowraise
fi


