#!/bin/bash
#
get_window_id() {
  local hex_addr="$1"
  local dec_addr
  dec_addr=$(printf '%d' "$hex_addr")
  grep -oP "\d+(?=\[HC>\](?:(?!\[HC>\]).)*\[HE>\]${dec_addr}\[HA>\])" <<<"$XDPH_WINDOW_SHARING_LIST"
}

unset WAYLAND_DEBUG
WORKSPACES="$(hyprctl monitors -j | jq -r 'map(.activeWorkspace.id)')"
WINDOWS="$(hyprctl clients -j | jq -r --argjson workspaces "$WORKSPACES" 'map(select([.workspace.id] | inside($workspaces)))')"
GEOM=$(echo "$WINDOWS" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp -o -b 11111bdd -c e64553ff -B 11111bdd -d -w 1 2>/dev/null)

if [[ -z "$GEOM" ]]; then
  exit 1
fi

GEOMWH=$(echo "$GEOM" | awk '{print $2}')
MONITOR="$(hyprctl activeworkspace -j | jq -r '.monitorID')"
SELECTEDMON="$(hyprctl monitors -j | jq -r '.[] | select(.id=='"$MONITOR"') | .name')"
MWH="$(hyprctl monitors -j | jq -r '.[] | select(.id=='"$MONITOR"') | .width,.height' | xargs | tr ' ' x)"

GEOM_X=$(echo "$GEOM" | cut -d',' -f1)
GEOM_Y=$(echo "$GEOM" | cut -d',' -f2 | cut -d' ' -f1)
GEOM_W=$(echo "$GEOM" | cut -d' ' -f2 | cut -d'x' -f1)
GEOM_H=$(echo "$GEOM" | cut -d' ' -f2 | cut -d'x' -f2)

SELECTEDWIN=$(echo "$WINDOWS" | jq -r \
  --argjson x "$GEOM_X" --argjson y "$GEOM_Y" \
  --argjson w "$GEOM_W" --argjson h "$GEOM_H" \
  'map(select(.at[0]==$x and .at[1]==$y and .size[0]==$w and .size[1]==$h)) | first | .address // empty')

SELECTEDWIN_ADDRESS="none"
if [[ -z "$SELECTEDWIN" ]]; then
  SELECTEDWIN="none"
  SELECTEDWIN_ADDRESS="none"
else
  SELECTEDWIN_ADDRESS=$(get_window_id "$SELECTEDWIN" 2>/dev/null || echo "none")
fi

FULLSCREEN="false"
if [[ "$MWH" = "$GEOMWH" ]]; then
  FULLSCREEN="true"
fi

echo "Monitor: $SELECTEDMON" >&2
echo "Window: $SELECTEDWIN" >&2
echo "Capturing: $GEOM" >&2
echo "Fullscreen: $FULLSCREEN" >&2

echo "$SELECTEDMON $SELECTEDWIN_ADDRESS $GEOM $FULLSCREEN $SELECTEDWIN"
