#!/bin/bash
video_path="$HOME/Videos/ScreenCaptures"
mkdir -p "$video_path"

w=$1
h=$2
running=`pgrep -f "gpu-screen-recorder" | wc -l`


if [ $running -eq 0 ]; then
  flatpak run --command="gpu-screen-recorder" com.dec05eba.gpu_screen_recorder  -w focused -s ${w}x${h} -f 60 -c mkv -r 60 -o "$video_path"   &
    exit 0
else 
    killall -SIGUSR1 gpu-screen-recorder && sleep 0.5 && notify-send -t 1500 -u low -- "GPU Screen Recorder" "ScreenCapture saved"
    killall -SIGINT gpu-screen-recorder
    exit 0
fi

notify-send $w $running