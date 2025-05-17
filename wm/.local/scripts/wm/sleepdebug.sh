#!/bin/bash

ghostty -e journalctl -f &
ghostty -e dmesg -w &
notify-send "Going to sleep in 5 seconds"
sleep 5
systemctl suspend
