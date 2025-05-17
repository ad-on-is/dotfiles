#!/bin/bash
notify-send "Connecting to Android tablet" "please wait..."
adb connect 10.40.30.150 && scrcpy
