-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.g.ai_cmp = false
-- vim.opt.completeopt = "menu,menuone,noselect"
-- vim.opt.wrap = true

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- vim.g.autoformat = function()
--   local f = vim.fn.expand("%:t")
--   vim.notify(f)
--   if vim.fn.index(ignored_autosave_files, vim.fn.fnamemodify(f, ":e")) ~= -1 then
--     return false
--   end
--   return true
-- end
-- vim.g.autoformat = false
vim.g.neovide_scale_factor = 1
vim.g.neovide_cursor_vfx_mode = "railgun"
vim.g.maplocalleader = ","
vim.opt.fillchars:append({ diff = " " })

vim.g.neovide_padding_top = 10
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 5
vim.g.neovide_padding_left = 5

vim.g.mkdp_auto_close = 0
vim.opt.colorcolumn = "140"
vim.opt.textwidth = 140

-- performance tuning
vim.lsp.set_log_level("off")
vim.g.matchparen_timeout = 10
vim.g.matchparen_insert_timeout = 10
vim.g.loaded_matchparen = 1
vim.opt.syntax = "off"
vim.o.foldenable = false
vim.o.spell = false
vim.g.lazyvim_php_lsp = "intelephense"

-- copy and paste with OSC52 on SSH

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

if os.getenv("SSH_TTY") ~= nil then
  vim.o.clipboard = "unnamedplus"
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end
