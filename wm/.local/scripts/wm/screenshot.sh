#!/bin/bash

SDIR="$HOME"/Pictures/Screenshots

if [[ ! -d "$SDIR" ]]; then
  mkdir -p "$SDIR"
fi

function gradient() {
  file=$1

  # Read both dimensions in one call; subtract shave (1px per edge = 2px total)
  read -r orig_width orig_height < <(identify -format "%w %h" "$file")
  width=$((orig_width - 2))
  height=$((orig_height - 2))

  min_dim=$((width < height ? width : height))
  padding=$(((min_dim * 70) / 500))
  [ "$padding" -lt 20 ] && padding=20
  new_width=$((width + padding))
  new_height=$((height + padding))
  radius=$((padding / 5)) # adjust this for more/less rounding

  tmp=$(mktemp /tmp/screenshot_XXXXXX.png)

  # Pass 1: shave slurp border + round corners → tmpfs
  magick "$file" \
    -depth 8 \
    -shave 1x1 \
    -alpha set \
    \( +clone -alpha transparent -background none \
    -fill white -draw "roundrectangle 0,0 $((width - 1)),$((height - 1)) ${radius},${radius}" \) \
    -compose DstIn -composite \
    "$tmp"

  # Pass 2: build blurred background, composite rounded image + shadow on top
  magick "$tmp" \
    -depth 8 \
    -background black -flatten \
    -resize 4x4! \
    -rotate 180 \
    -filter Gaussian \
    -resize ${new_width}x${new_height}! \
    \( "$tmp" \( +clone -background black -shadow "100x$radius+0+0" \) \
    +swap -background none -layers merge +repage \) \
    -gravity center -composite \
    "$file"

  rm -f "$tmp"
}

main() {

  SCRIPT_DIR=$(dirname "$(realpath "$0")")
  PICKED=$("$SCRIPT_DIR/"screenpicker.sh 2>/dev/null)

  if [[ "$?" -ne 0 ]]; then
    exit 1
  fi

  # MONITOR=$(echo "$PICKED" | awk '{print $1}')
  # WINDOW=$(echo "$PICKED" | awk '{print $2}')
  XY=$(echo "$PICKED" | awk '{print $3}')
  WH=$(echo "$PICKED" | awk '{print $4}')
  FULLSCREEN=$(echo "$PICKED" | awk '{print $5}')
  GEOM="$XY $WH"

  fname=$(date +'%Y-%m-%d_%H-%M-%S.png')
  file="$SDIR/$fname"
  res=""
  set -x
  if [[ "$FULLSCREEN" == "true" ]]; then
    res=$(grim -g "$GEOM" - | satty -o "$file" -f -)
  else
    grim -g "$GEOM" "$file"
    gradient "$file"
    wl-copy --type image/png <"$file"
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
    notify-send -a "Screenshot" -i "$file" "Captured!" "$text"
  fi

}

main
