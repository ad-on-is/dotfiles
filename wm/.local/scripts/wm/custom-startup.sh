#!/bin/env bash

# set -exuo pipefail
razer-cli -b 30 && razer-cli --dpi 800 2>/dev/null
# use eza to list NAS mounts (to mount automatically)
while true; do
  sleep 5
  folder=$(/home/adonis/.local/bin/devbox/eza -la -M /run/media/adonis/NAS | awk '{print $7}' | paste -s | xargs)
done
#
# x11apps=(
#   'sleep 1 && $HOME/.local/scripts/wm/screenlayout.sh && nitrogen --restore'
#   '$HOME/.local/bin/snixembed --fork'
#   #'xmodmap $HOME/.Xmodmap'
#   '$HOME/.local/bin/greenclip daemon'
#   '/usr/libexec/polkit-gnome-authentication-agent-1'
#   'xset -b'
#   #' vorta -d'
#   #'    bitwarden-desktop'
#   'flameshot'
#   #'  openrgb --startminimized'
#   #'udiskie --tray --no-notify'
#   '$HOME/.local/bin/picom --animations -b'
#   #'kdeconnect-indicator'
#   'xset r rate 500 80 # set kb repeat rate'
#   #'blueberry-tray && sleep 10 && bluetoothctl connect F8:5C:7D:90:B6:3B && sleep 10 && pactl set-default-sink bluez_output.F8_5C_7D_90_B6_3B.1'
#   'numlockx on'
#   'xset s off && xset -dpms && xset s noblank'
#   'ulauncher'
# )
#
# waylandapps=(
#   'ags -d $HOME/.config/ags2 run'
#   # 'ags -d $HOME/.config/ags2 run $HOME/.config/ags2/launcher.ts'
#   'swww-daemon --format xrgb &! ; sleep 1 ; $HOME/.local/scripts/wm/randomize-wallpaper.sh ~/Pictures/Wallpapers/Space &!'
#   'bun run $HOME/.config/hypr/hyprgoodies/index.ts'
#   'wl-paste --watch cliphist store'
# )
#
# commonapps=(
#   'corectrl --minimize-systray'
#   'flatpak run --command=cameractrls.py hu.irl.cameractrls -c zoom_absolute=100'
#   '/usr/libexec/geoclue-2.0/demos/agent'
#   'nm-applet'
#   'udiskie --tray'
#   #'blueberry-tray ; sleep 10 && bluetoothctl connect F8:5C:7D:90:B6:3B'
#   'docker stop portainer ; docker rm portainer ; docker run -d -p 8000:8000 -p 9443:9443 --name portainer  --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Development/Docker/portainer_data:/data portainer/portainer-ce:sts'
#   'docker compose -f $HOME/Development/Docker/docker-compose.yaml up -d --remove-orphans'
#   'razer-cli -b 30 && razer-cli --dpi 800'
#   #'flatpak run --command=resticity io.github.ad_on_is.Resticity --background'
#   'easyeffects --gapplication-service'
#   'flatpak run --command=valent ca.andyholmes.Valent --gapplication-service'
#   'flatpak run --command=emote com.tomjwatson.Emote --gapplication-service'
# )
#
# logfile=$HOME/.local/tmp/logs/adonis-autostart.log
# touch $logfile
# echo "" > $logfile
#
# function runApps {
#   local -a apps=("$@")
#   for app in "${apps[@]}"; do
#     zsh -c "$app 2> $logfile || notify-send 'adonis-autostart.sh' '$app'" &!
#   done
# }
#
#
# if [[ "$@" == "x11" ]]; then
#   runApps "${x11apps[@]}" &
# elif [[ "$@" == "wayland" ]]; then
#   runApps "${waylandapps[@]}" &
# fi
#
# sleep 5
# runApps "${commonapps[@]}" &
#
