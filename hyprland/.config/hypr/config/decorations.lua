local common = require("config._common")

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 3,
    border_size = 2,
    col = {
      active_border   = common.colors.primary,
      inactive_border = common.colors.secondary,
    }
    -- col.active_border=rgba(f9e2afff),
    -- col.inactive_border=rgba(b4befe30)
  },

  group = {
    auto_group = true,
    drag_into_group = 0,
    col = {
      border_active          = common.colors.group.active,
      border_inactive        = common.colors.group.inactive,
      border_locked_active   = common.colors.group.active,
      border_locked_inactive = common.colors.group.inactive,

    },

    groupbar = {
      height = 25,
      round_only_edges = false,
      indicator_height = 0,
      gradients = 1,
      gaps_in = 2,
      gaps_out = 0,
      font_size = 12,
      col = {
        active          = common.colors.group.bar.active,
        inactive        = common.colors.group.bar.inactive,
        locked_active   = common.colors.group.bar.active,
        locked_inactive = common.colors.group.bar.inactive,

      },

      text_color = common.colors.group.bar.text
    }
  },
  decoration = {
    rounding         = 7,
    rounding_power   = 7,

    dim_inactive     = false,
    dim_strength     = 0.1,
    dim_special      = 0.1,
    active_opacity   = 0.97,
    inactive_opacity = 0.95,

    shadow           = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = 0xee1a1a1a,
    },

    blur             = {
      enabled            = true,
      new_optimizations  = true,
      xray               = false,
      size               = 7,
      input_methods      = true,
      passes             = 2,
      vibrancy           = 0.4,
      brightness         = 1,
      noise              = 0.1,
      contrast           = 5,
      popups             = true,
      popups_ignorealpha = 0.6,
    },
  },

  animations = {
    enabled = true,
  },


})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("winBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("wsBezier", { type = "bezier", points = { { 0.15, 1 }, { 0.1, 1.01 } } })
hl.curve("rubber", { type = "spring", mass = 0.8, stiffness = 60, dampening = 9 })
hl.curve("rubberSmooth", { type = "spring", mass = 1.1, stiffness = 40, dampening = 11 })
hl.curve("overshoot", { type = "bezier", points = { { 0.5, 0.9 }, { 0.1, 1.1 } } })

hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
hl.curve("hobbyist", { type = "spring", mass = 1, stiffness = 40, dampening = 6 })
hl.curve("cat", { type = "spring", mass = 1, stiffness = 30, dampening = 6 })


-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 10, spring = "rubber" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 10, spring = "rubberSmooth" })
-- hl.animation({ leaf = "windowsOut", enabled = true, speed = 10, spring = "rubber" })
-- hl.animation({ leaf = "windows", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
-- hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
-- hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layers", enabled = true, speed = 10, spring = "rubber" })
-- hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
-- hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
-- hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
-- hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 10, spring = "rubberSmooth", style = "slidefade 80%" })
-- hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "slidefade" })
-- hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slidefade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })
