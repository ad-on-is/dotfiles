local common = require("config._common")

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

for i = 1, common.workspaces.count do
  hl.workspace_rule({
    workspace  = "1" .. i,
    monitor    = "DP-3",
    persistent = true,
  })

  hl.workspace_rule({
    workspace  = "2" .. i,
    monitor    = "HDMI-A-1",
    persistent = true,
  })
end
