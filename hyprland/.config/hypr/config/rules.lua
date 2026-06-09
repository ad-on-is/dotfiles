local log = require("config._log")

local floatingWindows = {
  { title = "^(blueberry.py|steam|guifetch|XTerm)$",                                                            class = "" },
  { title = "^(Open File|Select a File|Choose wallpaper|Open Folder|Save As|Do you want to save|Library)(.*)$", class = "" },
  { title = "",                                                                                                 class = "^(org.quickshell)$" },
  { title = "^(.*)(New archive|Create|Extract|Smart|Done)(.*)$",                                                class = "(peazip)" },
  { title = "Yaak Settings",                                                                                    class = "" },
  { title = "",                                                                                                 class = "^(io.github.diegopvlk.Cine)$" },
  { title = "",                                                                                                 class = "FortiClient" },
}

local bluringLayers = {
  "session",
  "bar",
  "dms:(.*)",
  "corner.*",
  "dock",
  "indicator.*",
  "gtk-layer-shell",
  "launcher",
  "notifications",
  "overview",
  "cheatsheet",
  "sideright",
  "sideleft",
  "osk",
  "swaync-control-center",
  "swaync-notification-window",
  "waybar",
  "vicinae",
  "quickshell(.*)?",
  "noctalia-background-*",
  "noctalia-bar",
  "walker"
}


hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name           = "suppress-maximize-events",
  match          = { class = ".*" },
  suppress_event = "maximize",
})

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name     = "fix-xwayland-drags",
  match    = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },

  no_focus = true,
})

hl.window_rule({
  name = "full-screen-satty",
  match = {
    title = "^(.*)satty(.*)$",
  },
  fullscreen = true,
})

hl.window_rule({
  name = "recording",
  match = {
    tag = "recording",
  },
  border_size = 3,
  border_color = "rgb(7ccf00) rgb(7ccf00)"
})



for i, w in ipairs(floatingWindows) do
  local r = { name = "float-" .. i, match = {}, float = true }
  if w.class ~= "" then
    r.match.class = w.class
  end
  if w.title ~= "" then
    r.match.title = w.title
  end
  hl.window_rule(r)
end

for i, w in ipairs(bluringLayers) do
  hl.layer_rule({
    name         = "blur-" .. i,
    match        = { namespace = w },
    blur         = true,
    ignore_alpha = 0.6,
  })
end

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)
