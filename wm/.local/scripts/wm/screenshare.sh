#!/bin/bash
#
function main() {

  SCRIPT_DIR=$(dirname "$(realpath "$0")")
  PICKED=$("$SCRIPT_DIR/"screenpicker.sh 2>/dev/null )

  if [[ "$?" -ne 0 ]]; then
    exit 1
  fi

  MONITOR=$(echo "$PICKED" | awk '{print $1}')
  WINDOW=$(echo "$PICKED" | awk '{print $2}')
  XY=$(echo "$PICKED" | awk '{print $3}')
  WH=$(echo "$PICKED" | awk '{print $4}')
  FULLSCREEN=$(echo "$PICKED" | awk '{print $5}')
  GEOM="$XY $WH"
  $(printenv | rg XDPH > /tmp/xdph_test)


  if [[ "$WINDOW" != "none" ]]; then
    echo "[SELECTION]/window:$WINDOW"
    exit 0
  fi

  if [[ "$FULLSCREEN" == "true" ]]; then
    echo "[SELECTION]/screen:$MONITOR"
    exit 0
  fi

  if [[ -n "$GEOM" ]]; then
    echo "[SELECTION]/region:$MONITOR@$GEOM"
    exit 0
  fi
  exit 1
}

main "$@"
