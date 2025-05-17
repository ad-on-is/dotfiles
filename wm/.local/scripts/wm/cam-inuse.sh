#!/bin/bash
# exec {lock_fd}>/home/adonis/.local/tmp/awesome-alsa-in.lock || exit 1
# flock -n "$lock_fd" || { echo "ERROR: flock() failed." >&2; exit 1; }
devices=$(lsof /dev/video* 2> /dev/null | tail -n +2 | awk '{print $NF}' | uniq)


for d in $devices
do
  name=$(pw-cli list-objects Node | rg -A 7 $d | rg node.description | awk -F '[""]' '{print $2}' | awk -F ' ' '{print $1 " " $2 " " $3}')
  if [ -n "$name" ];then
    echo $name
  fi
done