local options = {

  base46 = {
    theme = "catppuccin",
    transparent = true,
  },

  ui = {
    cmp = {
      lspkind_text = false,
      style = "atom_colored", -- default/flat_light/flat_dark/atom/atom_colored
      format_colors = {
        tailwind = true,
      },
    },

    lsp = { signature = true },
    colorify = {
      enabled = false,
    },
  },
}

return options
