-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.g.ai_cmp = false
-- vim.opt.completeopt = "menu,menuone,noselect"
-- vim.opt.wrap = true
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.g.neovide_scale_factor = 1
vim.g.neovide_cursor_vfx_mode = "railgun"

vim.g.neovide_padding_top = 10
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 5
vim.g.neovide_padding_left = 5

vim.g.mkdp_auto_close = 0

-- performance tuning
vim.lsp.set_log_level("off")
vim.g.matchparen_timeout = 10
vim.g.matchparen_insert_timeout = 10
vim.g.loaded_matchparen = 1
vim.opt.syntax = "off"
vim.o.foldenable = false
vim.o.spell = false
vim.g.lazyvim_php_lsp = "intelephense"

-- vim.o.clipboard = "unnamedplus"
--
-- local function paste()
--   return {
--     vim.fn.split(vim.fn.getreg(""), "\n"),
--     vim.fn.getregtype(""),
--   }
-- end
--
-- vim.g.clipboard = {
--   name = "OSC 52",
--   copy = {
--     ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
--     ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
--   },
--   paste = {
--     ["+"] = paste,
--     ["*"] = paste,
--   },
-- }

-- vim.opt.number = true
-- vim.opt.relativenumber = true
-- vim.o.statuscolumn = "%l [%r] %s" -- show signs, line number, and relative line number
