#!/bin/bash
# exec {lock_fd}>/home/adonis/.local/tmp/awesome-alsa-in.lock || exit 1
# flock -n "$lock_fd" || { echo "ERROR: flock() failed." >&2; exit 1; }

info=$(pw-cli info $(pactl get-default-source))
volume=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -E -o "[[:digit:]]+%" | head -1 | grep -E -o "[[:digit:]]+")
status=$(pactl get-source-mute @DEFAULT_SOURCE@  | grep "yes" > /dev/null && echo "OFF" || echo "ON")
name=$( echo "$info" | grep node.nick | awk -F '[""]' '{print $2}' | cut -d" " -f1-3)
use=$( echo "$info" | grep state | awk '{print $3}' | tr  -cd '[:alpha:]')
echo $status
echo $volume
echo $name
echo $use
# flock -u "$lock_fd"
# echo $source
