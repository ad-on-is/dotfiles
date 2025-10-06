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
        neovide_padding_top = 10,
        neovide_padding_bottom = 0,
        neovide_padding_right = 5,
        neovide_padding_left = 5,
        neovide_cursor_vfx_mode = "railgun",
      },
    },
  },
}
