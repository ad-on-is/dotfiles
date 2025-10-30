if not vim.g.neovide then
  return {} -- do nothing if not in a Neovide session
end

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    options = {
      g = { -- configure vim.g variables
        -- configure scaling
        -- configure padding
        neovide_scale_factor = 1.0,
        neovide_padding_top = 10,
        neovide_padding_bottom = 0,
        neovide_padding_right = 5,
        neovide_padding_left = 5,
        neovide_cursor_vfx_mode = "railgun",
        neovide_window_blurred = true,
        -- neovide_transparency = 0.95,
        -- neovide_floating_blur_amount_x = 20.0,
        -- neovide_floating_blur_amount_y = 20.0,
        -- neovide_floating_z_height = 10,
        -- neovide_light_radius = 5,
        -- neovide_input_use_logo = 1,
        -- winblend = 30,
        -- pumblend = 20,
      },
    },
  },
}
