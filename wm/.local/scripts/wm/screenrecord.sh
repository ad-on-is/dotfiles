#!/bin/bash
function main() {

  SDIR="$HOME"/Videos/ScreenCaptures

  if [ ! -d "$SDIR" ]; then
    mkdir -p "$SDIR"
  fi
  recordfile=$(ps aux | grep wl-screenrec | grep -v grep | awk '{print $(NF-0)}' | awk -F'/' '{print $(NF-0)}')
  screenshotfile=/tmp/screenrecord_screenshot.png
  if [ -n "$recordfile" ]; then
    notify-send -a "ScreenRecorder" -i $screenshotfile "󰹑  Finished!" " $recordfile"
    killall -SIGINT wl-screenrec
    exit 0
  fi

  SCRIPT_DIR=$(dirname "$(realpath "$0")")
  PICKED=$("$SCRIPT_DIR/"screenpicker.sh 2>/dev/null)

  if [[ "$?" -ne 0 ]]; then
    exit 1
  fi

  # MONITOR=$(echo "$PICKED" | awk '{print $1}')
  # WINDOW=$(echo "$PICKED" | awk '{print $2}')
  XY=$(echo "$PICKED" | awk '{print $3}')
  WH=$(echo "$PICKED" | awk '{print $4}')
  # FULLSCREEN=$(echo "$PICKED" | awk '{print $5}')
  # ADDRESS=$(echo "$PICKED" | awk '{print $6}')
  GEOM="$XY $WH"
  recordfile=ScreenCapture-$(date +'%Y-%m-%d_%H:%M:%S.mp4')
  file="$SDIR/$recordfile"

  if [[ -z "$GEOM" ]]; then
    exit 0
  fi

  grim -g "$GEOM" $screenshotfile
  notify-send -a "ScreenRecorder" -i $screenshotfile "󰹑 Recording ..." " $recordfile"

  wl-screenrec --codec=hevc --ffmpeg-encoder-options "qp=22" --gop-size 120 --max-fps 60 -g "$GEOM" -f "$file"
}

main "$@"
