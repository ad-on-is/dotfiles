#!/bin/bash
name=`wpctl inspect @DEFAULT_AUDIO_SOURCE@ | grep "node.description" | cut -d "=" -f 2 | sed 's/\"//g' | awk '{print $1, $2, $3}'`
volume=`wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print $2}' | bc -l | awk '{print int($1*100)}'`
status=`wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep "MUTED" > /dev/null && echo "OFF" || echo "ON"`
use=`wpctl status | grep "$name" | grep "input_MONO" | grep "[active]" > /dev/null && echo "inuse" || echo "suspended"`
echo $status
echo $volume
echo $name
echo $use