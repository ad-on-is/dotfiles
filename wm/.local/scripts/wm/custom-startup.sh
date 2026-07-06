#!/bin/env bash

# set -exuo pipefail
razer-cli -b 30 && razer-cli --dpi 800 2>/dev/null
eval $(gnome-keyring-daemon --start --components=ssh,secrets)
systemctl --user import-environment SSH_AUTH_SOCK GNOME_KEYRING_CONTROL
fcitx5 &
/usr/libexec/polkit-gnome-authentication-agent-1 &
# use eza to list NAS mounts (to mount automatically)
while true; do
  sleep 5
  folder=$(eza -la -M /run/media/adonis/NAS | awk '{print $7}' | paste -s | xargs)
done
