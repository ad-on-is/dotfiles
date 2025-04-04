# hyprgoodies

A small collection of scripts for Hyprland.

## Install dependencies

```bash
bun install
```

## Workspaces

This allows you to have multiple workspaces on each monitor, and switch between them, or move windows between them
It is important to name the workspaces `11, 12, 13`, etc. for one monitor and `21, 22, 23`, for the second monitor, etc.

```
# example workspaces
workspace=11, monitor:DP-1, persistent:true, default:true
workspace=12, monitor:DP-1, persistent:true
workspace=13, monitor:DP-1, persistent:true

workspace=21, monitor:DP-2, persistent:true, default:true
workspace=22, monitor:DP-2, persistent:true
workspace=23, monitor:DP-2, persistent:true

workspace=31, monitor:HDMI-A-1, persistent:true, default:true
workspace=32, monitor:HDMI-A-1, persistent:true
workspace=33, monitor:HDMI-A-1, persistent:true

workspace=41, monitor:DP-3, persistent:true, default:true
workspace=42, monitor:DP-3, persistent:true
workspace=43, monitor:DP-3, persistent:true

# example keybinding
bind=SUPER,h,exec, bash -c 'bun ~/.config/hypr/hyprgoodies/actions.ts workspace switch prev'
bind=SUPER,l,exec, bash -c 'bun ~/.config/hypr/hyprgoodies/actions.ts workspace movewindow next'
```

## Floating window

This let's you toggle between a tiled and floating window. If it is tiled, it will switch to floating, centered, and it's size will be 80% of the screen.
You can also customize the sizing to a different value.

```
bind=SUPER,d,exec, bash -c 'bun ~/.config/hypr/hyprgoodies/actions.ts toggleFloating'
```
