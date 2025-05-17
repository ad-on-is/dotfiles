#!/bin/bash

name=`wpctl inspect @DEFAULT_AUDIO_SINK@ | grep "node.description" | awk '{print $4}' | sed 's/"//g'`
volume=`wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}' | bc -l | awk '{print int($1*100)}'`
status=`wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep "MUTED" > /dev/null && echo "OFF" || echo "ON"`

echo $status
echo $volume
echo $name