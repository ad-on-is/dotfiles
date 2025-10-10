#!/usr/bin/env bash

function set_wallpaper() {
  WALLPAPER_DIR="$1"
  CURRENT_WALL=$(hyprctl hyprpaper listloaded)

  # Get a random wallpaper that is not the current one
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

  # Apply the selected wallpaper
  hyprctl hyprpaper reload ,"$WALLPAPER"
}

while true; do
  set_wallpaper "$1"
  sleep 300
done
