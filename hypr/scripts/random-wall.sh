#!/usr/bin/env bash

# Cooldown
COOLDOWN="/tmp/wallpaper_change_cooldown"
[ -e "$COOLDOWN" ] && exit
touch "$COOLDOWN"

#wallpapers directory
DIR="/home/fiw/wallpapers"
FILE=$(find "$DIR" -type f | shuf -n 1)

# Animation - Updated swww to awww
awww img "$FILE" \
    --transition-type outer \
    --transition-step 200 \
    --transition-fps 60 \
    --transition-duration 1.2 \
    --namespace wayland-1

#Wait 1.5s for cooldown to work
sleep 1.5
rm "$COOLDOWN"
