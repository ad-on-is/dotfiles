#!/bin/bash

# check with ps aux if waydroid is running

if [ -z "$(ps aux | grep waydroid | grep -v grep)" ]; then
    notify-send "Launching waydroid emulator"
    weston --socket=waydroidsocket &
    sleep 15
fi

ip=$(waydroid status | rg IP | awk '{print $3}')
notify-send "Launching waydroid emulator"
adb connect $ip
scrcpy &
sleep 1
pkill weston
