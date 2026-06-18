-- exec-once = uwsm app -- dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
-- exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
-- #exec-once = uwsm app -- bash -c '~/.local/scripts/wm/hyprland-desktop-portal.sh'
-- exec-once = hyprctl setcursor Adwaita 24
-- exec-once = uwsm app -- hyprpaper
-- exec-once = uwsm app -- bash -c "bun ~/.config/hypr/hyprgoodies/monitors.ts"
-- exec-once = uwsm app -- bash -c 'sleep 1 && ~/.local/scripts/wm/hyprpaper-random-wp.sh ~/Pictures/Wallpapers/Nightsky/'
-- exec-once = uwsm app -- bash -c '/usr/libexec/polkit-gnome-authentication-agent-1'
-- exec-once = uwsm app -- fcitx5
-- exec-once = bash -c 'USE_LAYER_SHELL=0 vicinae server'
-- exec-once = uwsm app -- bash -c 'eval $(gnome-keyring-daemon --start --components=ssh,secrets,pkcs11)'
-- ; exec-once = hyprpm reload
hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -- dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") -- Execute waybar, hyprpaper, firefox
  hl.exec_cmd("hyprctl setcursor Adwaita 24")                                            -- Execute waybar, hyprpaper, firefox
end)
