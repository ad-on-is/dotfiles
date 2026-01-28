#!/bin/bash

SDIR="$HOME"/Pictures/Screenshots

if [[ ! -d "$SDIR" ]]; then
  mkdir -p "$SDIR"
fi

function gradient() {
  file=$1
  width=$(identify -format "%w" "$file")
  height=$(identify -format "%h" "$file")
  padding=30
  new_width=$((width + padding))
  new_height=$((height + padding))
  radius=$((padding / 3)) # adjust this for more/less rounding
  gradient1="#fb64b6"
  gradient2="#9169f7"

  convert "$file" \
    -alpha set \
    \( +clone -alpha transparent -background none \
    -fill white -draw "roundrectangle 0,0 $((width - 1)),$((height - 1)) ${radius},${radius}" \) \
    -compose DstIn -composite \
    "$file"

  # Add shadow and composite onto gradient
  convert -size ${new_width}x${new_height} "gradient:$gradient1-$gradient2" \
    \( "$file" \( +clone -background black -shadow 100x5+0+0 \) \
    +swap -background none -layers merge +repage \) \
    -gravity center -composite \
    "$file"

  # rm /tmp/tmp_rounded.png
}

WORKSPACES="$(hyprctl monitors -j | jq -r 'map(.activeWorkspace.id)')"
MONITOR="$(hyprctl activeworkspace -j | jq -r '.monitorID')"
MWH="$(hyprctl monitors -j | jq -r '.[] | select(.id=='"$MONITOR"') | .width,.height' | xargs | tr ' ' x)"
WINDOWS="$(hyprctl clients -j | jq -r --argjson workspaces "$WORKSPACES" 'map(select([.workspace.id] | inside($workspaces)))')"
GEOM=$(echo "$WINDOWS" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp -o -b 11111bdd -c e64553ff -B 11111bdd -d -w 1)
GEOMWH=$(echo "$GEOM" | awk '{print $2}')

if [[ -z "$GEOM" ]]; then
  exit 0
fi

fname=$(date +'%Y-%m-%d_%H-%M-%S.png')
file="$SDIR/$fname"
res=""
if [[ "$MWH" = "$GEOMWH" ]]; then
  res=$(grim -g "$GEOM" - | satty -o "$file" -f -)
else
  grim -g "$GEOM" "$file"
  gradient "$file"
  cat "$file" | wl-copy
  res="clipboard File saved"
fi

clipboard=$(echo "$res" | grep -o "clipboard")
saved=$(echo "$res" | grep -o "File saved")
text=""
if [[ -n $saved ]]; then
  text=" $fname"
fi
if [[ -n $clipboard ]]; then
  text="$text\n󰢨 Copied to clipboard"
fi

if [[ -n $text ]]; then
  notify-send -i "$file" "Screenshot captured!" "$text"
fi
