#!/bin/bash
SDIR="$HOME"/Videos/ScreenCaptures

if [ ! -d "$SDIR" ]; then
  mkdir -p "$SDIR"
fi
recordfile=$(ps aux | grep wl-screenrec | grep -v grep | awk '{print $(NF-0)}' | awk -F'/' '{print $(NF-0)}')

if [ -n "$recordfile" ]; then
  notify-send -i /tmp/screenshot.png "󰹑 Recording stopped!" " $recordfile"
  pkill -f wl-screenrec
  exit 0
fi

WORKSPACES="$(hyprctl monitors -j | jq -r 'map(.activeWorkspace.id)')"
WINDOWS="$(hyprctl clients -j | jq -r --argjson workspaces "$WORKSPACES" 'map(select([.workspace.id] | inside($workspaces)))')"
GEOM=$(echo "$WINDOWS" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp -o -b 11111bdd -c e64553ff -B 11111bdd -d -w 1)
recordfile=ScreenCapture-$(date +'%Y-%m-%d_%H:%M:%S.mp4')
file="$SDIR/$recordfile"
screenshotfile=/tmp/screenshot.png

if [[ -z "$GEOM" ]]; then
  exit 0
fi

grim -g "$GEOM" $screenshotfile
notify-send -i $screenshotfile "󰹑 Recording started!" " $recordfile"

wl-screenrec -g "$GEOM" -f $file
