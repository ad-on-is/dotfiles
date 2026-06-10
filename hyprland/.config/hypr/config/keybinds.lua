local terminal       = "ghostty"
local fileManager    = "nemo"
local launcher       = "dms ipc call spotlight openWith apps"
local clipboard      = "dms ipc call clipboard toggle"
local adbKeyBack     = "~/.local/share/android/Sdk/platform-tools/adb shell input keyevent KEYCODE_BACK"
local screenShot     = "~/.local/scripts/wm/screenshot.sh"
local screenRecord   = "~/.local/scripts/wm/screenrecord.sh"
local cameraZoom     = "~/.local/scripts/wm/camctrl.sh zoom"
-- local cameraSwitch = "~/.local/scripts/wm/camctrl.sh zoom"

local volUp          = "pactl set-sink-volume @DEFAULT_SINK@ +2%"
local volDown        = "pactl set-sink-volume @DEFAULT_SINK@ -2%"
local volMute        = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
local windowSwitcher = "dms ipc call spotlight openQuery '!'"
local emojiPicker    = "dms ipc call spotlight openQuery ':e '"
local gifPicker      = "dms ipc call spotlight openQuery ':g '"

local micUp          = "pactl set-source-volume @DEFAULT_SOURCE@ +2%"
local micDown        = "pactl set-source-volume @DEFAULT_SOURCE@ -2%"
local micMute        = "pactl set-source-mute @DEFAULT_SOURCE@ toggle"
local headphones     = "pactl set-default-sink alsa_output.pci-0000_0c_00.4.analog-stereo"
local btSpeaker      = "pactl set-default-sink bluez_output.F8_5C_7D_90_B6_3B.1"

local common         = require("config._common")

local s              = "SUPER + "
local ss             = s .. "SHIFT + "
local sc             = s .. "CTRL + "
local sa             = s .. "ALT + "
local ssc            = s .. "CTRL + "

hl.bind(ss .. "ESCAPE", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("systemctl suspend"))

hl.bind(ssc .. "ESCAPE", hl.dsp.exec_cmd("uwsm stop > /tmp/uwsm.log")) -- logout


-- APPS
hl.bind(s .. "RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(s .. "N", hl.dsp.exec_cmd(fileManager))

hl.bind(s .. "SPACE", hl.dsp.exec_cmd(launcher))
hl.bind(s .. "V", hl.dsp.exec_cmd(clipboard))


hl.bind(s .. "ESCAPE", hl.dsp.exec_cmd(adbKeyBack))

hl.bind(sa .. "E", hl.dsp.exec_cmd(emojiPicker))
hl.bind(sa .. "G", hl.dsp.exec_cmd(gifPicker))

-- GROUPS
hl.bind(s .. "G", function() common.group() end)
hl.bind(ss .. "G", hl.dsp.group.toggle())
hl.bind(s .. "R", hl.dsp.group.prev())
hl.bind(s .. "T", hl.dsp.group.next())
hl.bind(sa .. "R", hl.dsp.group.move_window({ forward = false }))
hl.bind(sa .. "T", hl.dsp.group.move_window())

-- WINDOW
hl.bind(s .. "tab", hl.dsp.exec_cmd(windowSwitcher))
hl.bind(s .. "Q", hl.dsp.window.close())
hl.bind(s .. "F", hl.dsp.window.fullscreen())
hl.bind(s .. "U", hl.dsp.window.toggle_swallow())
hl.bind(s .. "D", function()
  common.float(false)
end)
hl.bind(s .. "P", function()
  common.float(true)
end)


hl.bind(s .. "P", hl.dsp.window.float({ action = "toggle" })) -- pin
hl.bind(s .. "Z", hl.dsp.window.float({ action = "toggle" })) -- fix to monitor

hl.bind(s .. "1", function()
  hl.config({
    general = {
      layout = "dwindle",
    },
  })
end)

hl.bind(s .. "2", function()
  hl.config({
    general = {
      layout = "grid",
    },
  })
end)

hl.bind(s .. "3", function()
  hl.config({
    general = {
      layout = "scrolling",
    },
  })
end)


-- hl.bind(s .. "M", hl.dsp.window.move({ workspace = "special:minimized" }))
-- bring back
-- hl.bind(ss .. "M", hl.dsp.window.move({ workspace = "special:minimized" }))

-- WORKSPACES
hl.bind(s .. "H", function() common.workspaces:focusPrev() end)
hl.bind(s .. "code:47", function() common.workspaces:focusNext() end)
hl.bind(sa .. "H", function() common.workspaces:movePrev() end)
hl.bind(sa .. "code:47", function() common.workspaces:moveNext() end)


-- MOVEMENT
hl.bind(s .. "I", hl.dsp.focus({ direction = "up" }))
hl.bind(s .. "J", hl.dsp.focus({ direction = "left" }))
hl.bind(s .. "K", hl.dsp.focus({ direction = "down" }))
hl.bind(s .. "L", hl.dsp.focus({ direction = "right" }))

hl.bind(s .. "O", hl.dsp.focus({ window = "next" }))
-- hl.bind(sa .. "O", hl.dsp.swap())

hl.bind(sa .. "I", hl.dsp.window.move({ direction = "up" }))
hl.bind(sa .. "J", hl.dsp.window.move({ direction = "left" }))
hl.bind(sa .. "K", hl.dsp.window.move({ direction = "down" }))
hl.bind(sa .. "L", hl.dsp.window.move({ direction = "right" }))

-- MULTIMEDIA
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volUp), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(volMute), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volDown), { locked = true, repeating = true })

hl.bind(sa .. "code:60", hl.dsp.exec_cmd(volUp), { locked = true, repeating = true })
hl.bind(sa .. "code:59", hl.dsp.exec_cmd(volMute), { locked = true, repeating = true })
hl.bind(sa .. "M", hl.dsp.exec_cmd(volDown), { locked = true, repeating = true })

hl.bind(ss .. "code:60", hl.dsp.exec_cmd(micUp), { locked = true, repeating = true })
hl.bind(ss .. "code:59", hl.dsp.exec_cmd(micMute), { locked = true, repeating = true })
hl.bind(ss .. "M", hl.dsp.exec_cmd(micDown), { locked = true, repeating = true })



hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(micMute), { locked = true, repeating = true })
hl.bind(s .. "XF86AudioRaiseVolume", hl.dsp.exec_cmd(micUp), { locked = true, repeating = true })
hl.bind(s .. "XF86AudioLowerVolume", hl.dsp.exec_cmd(micDown), { locked = true, repeating = true })
hl.bind(s .. "XF86AudioMute", hl.dsp.exec_cmd(micMute), { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(ss .. "1", hl.dsp.exec_cmd(screenShot))
hl.bind(ss .. "2", function()
  hl.dispatch(hl.dsp.window.tag({ tag = "recording" }))
  hl.dispatch(hl.dsp.exec_cmd(screenRecord))
end)

hl.bind(sa .. "1", hl.dsp.exec_cmd(headphones))
hl.bind(sa .. "2", hl.dsp.exec_cmd(btSpeaker))
hl.bind(sa .. "5", hl.dsp.exec_cmd(cameraZoom))
-- hl.bind(sa .. "6", hl.dsp.exec_cmd(cameraSwitch))


-- MOUSE
hl.bind(s .. "mouse:272", hl.dsp.window.drag())
hl.bind(s .. "mouse:273", hl.dsp.window.resize(), { mouse = true })




-- closeWindowBind:set_enabled(false)
-- hl.bind(mainMod .. " + M",
--   hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
-- hl.bind(mainMod .. " + ", hl.dsp.exec_cmd(fileManager))
-- hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
-- hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- -- Move focus with mainMod + arrow keys
-- hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
-- hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
-- hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
-- hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- -- Switch workspaces with mainMod + [0-9]
-- -- Move active window to a workspace with mainMod + SHIFT + [0-9]
-- for i = 1, 10 do
--   local key = i % 10 -- 10 maps to key 0
--   hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
--   hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
-- end

-- -- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- -- Scroll through existing workspaces with mainMod + scroll
-- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- -- Move/resize windows with mainMod + LMB/RMB and dragging
-- hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
-- hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
