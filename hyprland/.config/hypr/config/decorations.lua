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
      passes             = 3,
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

hl.curve("rubber", { type = "spring", mass = 0.8, stiffness = 60, dampening = 9 })
hl.curve("rubberSmooth", { type = "spring", mass = 1.1, stiffness = 40, dampening = 11 })

hl.animation({ leaf = "global", enabled = true, speed = 10, spring = "rubberSmooth" })
hl.animation({ leaf = "windows", enabled = true, speed = 10, spring = "rubber" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 10, spring = "rubberSmooth" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, spring = "rubber" })
hl.animation({ leaf = "layers", enabled = true, speed = 10, spring = "rubber" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 10, spring = "rubberSmooth", style = "slidefade 80%" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, spring = "rubber" })
