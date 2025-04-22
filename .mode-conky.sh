#!/bin/bash

ACTION=$1

# Define the conky config dir
CONFIG_DIR="$HOME/.config/conky"

# Get all the .conf files
#CONFIGS=($(find "$CONKY_CONFIG_DIR" -maxdepth 1 -name "*.conf" | sort))
CONFIGS=("$CONFIG_DIR"/*.conf)

# Check if conky is running
IS_ACTIVE=$(pgrep -af "conky -c $CONFIG_DIR" | head -n1)

if [[ -n "$IS_ACTIVE" ]]; then
    ACTIVE_CONF=$(echo "$IS_ACTIVE" | grep -o "$CONFIG_DIR/[^ ]\+\.conf")
    for i in "${!CONFIGS[@]}"; do
        if [[ "${CONFIGS[$i]}" == "$ACTIVE_CONF" ]]; then
	    INDEX=$i
            break
        fi
    done
    pkill -f "conky -c $ACTIVE_CONF"
else
    INDEX=-1
fi

# Handle action
case "$ACTION" in
    next)
        NEXT_INDEX=$(( (INDEX + 1) % ${#CONFIGS[@]} ))
        conky -c "${CONFIGS[$NEXT_INDEX]}" -D &
        ;;
    prev)
        PREV_INDEX=$(( (INDEX - 1 + ${#CONFIGS[@]}) % ${#CONFIGS[@]} ))
        conky -c "${CONFIGS[$PREV_INDEX]}" -D &
        ;;
    show_monitor|"")
        conky -c "${CONFIGS[0]}" -D &
        ;;
    show_help)
        conky -c "${CONFIGS[1]}" -D &
        ;;
    *)
        notify-send "~/.mode_conky.sh" " Conky failed to start"
        exit 1
        ;;
esac

# Raise the window
xdotool search --sync --classname "conky" windowraise
