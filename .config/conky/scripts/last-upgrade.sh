#!/bin/bash

echo $(( ( $(date +%s) - $(date -d "$(grep 'upgraded' /var/log/pacman.log | tail -n 1 | awk -F'[][]' '{print $2}')" +%s) ) / 86400 ))
