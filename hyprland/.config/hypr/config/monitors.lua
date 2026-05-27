local c = require("config._common")

hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = "auto",
})

hl.monitor({
  output   = "DP-3",
  mode     = "3440x1440@180",
  position = "0x0",
  scale    = "auto",
  vrr      = 2,
  -- bitdepth = 10

})

hl.monitor({
  output   = "HDMI-A-1",
  mode     = "3440x1440",
  position = "0x-1440",
  scale    = "auto",

})

for i, m in ipairs(hl.get_monitors()) do
  for w = 1, c.workspaces.count do
    hl.workspace_rule({
      workspace  = i .. w,
      monitor    = m.name,
      persistent = true,
    })
  end
end
