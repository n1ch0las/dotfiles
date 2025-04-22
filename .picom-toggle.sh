#!/bin/bash

if pgrep -x picom > /dev/null; then
    notify-send -t 1500 "Picom stopped" && pkill picom
else
    picom -b && notify-send -t 1500 "Picom started"
fi

