#!/bin/bash
# clear-current-workspace.sh

current_ws=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
i3-msg "[workspace=\"$current_ws\"] kill"
