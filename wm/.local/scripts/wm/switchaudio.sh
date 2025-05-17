#!/bin/bash

device=`wpctl status | grep "$1" | grep "vol" | awk '{print $2$3}' | tr -d -c 0-9`
echo $device
wpctl set-default $device