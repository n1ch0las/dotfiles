#!/bin/bash

# ChatGPT - a simple version of i3lock-fancy without ugly lock icons

# Define variables. i3lock only supports loading PNG files.
IMAGE_PATH="/home/mentat/.lockscreen/tmp/lockscreen" 

# Take a screenshot, will overwrite existing file.
# Use JPEG since it is faster and smaller. Scrot is fastest.
scrot --quality 1 --file "${IMAGE_PATH}.jpg" --overwrite

# Pixelate the screenshot and output as PNG as i3lock only supports
# loading PNG files. graphicsMagick is fastest.
gm convert "${IMAGE_PATH}.jpg" -scale 10% -scale 1000% "${IMAGE_PATH}.png"

# Lock the screen with the final image. Using exec replaces the current
# process which should help xss-lock keep track of the lock state...?
exec i3lock -i "${IMAGE_PATH}.png" --nofork

