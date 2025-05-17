#!/bin/sh
#focusedmon>>DP-2,21


numworkspaces=3
monitors=$(hyprctl monitors -j | jq -r '.[]')
echo $monitors




function handle {
  if [[ ${1:0:9} == "workspace" ]]; then
    echo "OK"
    # idx=${1:11:2}
    # mod=$(($idx % 10))
    # if [[ $mod -gt 3 ]]; then
    # return
    # fi
    # if [[ $mod -lt 1 ]]; then
    # return
    # fi
    # echo $mod
  fi
}

# socat - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read line; do handle $line; done
