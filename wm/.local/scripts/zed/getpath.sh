#!/bin/bash

input=$(/usr/bin/wl-paste)
path=$(dirname "$input")
echo "$path"
echo "$path" | /usr/bin/wl-copy
