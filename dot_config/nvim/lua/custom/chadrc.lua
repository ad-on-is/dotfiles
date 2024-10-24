---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "catppuccin",
  theme_toggle = { "catppuccin", "tokyodark" },

  hl_override = highlights.override,
  hl_add = highlights.add,
  transparency = true,
  lsp_semantic_tokens = true,
  telescope = {
    style="borderless"
  },
  statusline = {
    theme="vscode_colored",
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
