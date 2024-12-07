-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local funcs = require("config.functions")
-- local menu = require("menu")
local map = vim.keymap.set
-- local menuoptions = require("config.menu")
--
local function maphelper(key, n, v, i, desc, remap)
  map("n", key, n, { desc = desc, silent = true, remap = remap or false })
  map("v", key, v, { desc = desc, silent = true, remap = remap or false })
  map("i", key, i, { desc = desc, silent = true, remap = remap or false })
end
--
local function maphelper2(key, c, desc, remap)
  maphelper(key, c, c, c, desc, remap)
end
--
maphelper("<S-down>", "V<Down>", "<Down>", "<Esc>v<Down>", "Select line up")
maphelper("<S-up>", "V<Up>", "<Up>", "<Esc>v<Up>", "Select line down")
maphelper("<C-a>", "ggVG", "ggVG", "<Esc>ggVG<CR>", "Select all")
maphelper("<C-c>", "y", "y", "<Esc>y", "Copy")
maphelper("<C-z>", ":undo<CR>", ":undo<CR>", "<Esc>:undo<CR>", "Undo")
maphelper("<C-y>", ":redo<CR>", ":redo<CR>", "<Esc>:redo<CR>", "Undo")
-- -- clear highlighting
maphelper("<C-ö>", "gcc", "gc", "<Esc>gcc<CR>", "Toggle comment", true)
maphelper("<C-s>", ":w<CR>", ":w<CR>", "<Esc>:w<CR>", "Save")
maphelper("<C-x>", ":qa!<CR>", ":qa!<CR>", "<Esc>:qa!<CR>", "Quit", true)
maphelper("<A-d>", "yyp", "yyp", "<Esc>yyp", "Duplicate line")
maphelper("<A-down>", ":m .+1<CR>g=v", ":m '>+1<CR>gv=gv", "<Esc>:m .+1<CR>==gi", "Move line down")
maphelper("<A-up>", ":m .-2<CR>g=v", ":m '<-2<CR>gv=gv", "<Esc>:m .-2<CR>==gi", "Move line up")
--
map("n", "d", '"_d')
map("v", "d", '"_d')

-- Select
map("n", "<S-Right>", "v<Right>", { noremap = true, silent = true })
map("n", "<S-Left>", "v<Left>", { noremap = true, silent = true })
map("v", "<S-Right>", "<Right>", { noremap = true, silent = true })
map("v", "<S-Left>", "<Left>", { noremap = true, silent = true })
map("i", "<S-Right>", "<C-o>v<Right>", { noremap = true, silent = true })
map("i", "<S-Left>", "<C-o>v<Left>", { noremap = true, silent = true })

map("n", "<BS>", "Xi", { noremap = true, silent = true })
map("v", "<BS>", "di", { noremap = true, silent = true })

--
-- -- Telescope
-- --
maphelper2("<C-.>", vim.lsp.buf.code_action, "Commands")
maphelper2("<C-q>", function()
  Snacks.bufdelete()
end, "Close current file")
-- maphelper2("<C-l>", function()
--   require("nvchad.tabufline").move_buf(1)
-- end, "Move right")
maphelper2("<C-p>", "<cmd> Telescope find_files <CR>", "Worktree files")
maphelper2("<C-u>", "<cmd> Telescope buffers <CR>", "Used files")
maphelper2("<C-r>", "<cmd> Telescope oldfiles <CR>", "Recent files")
maphelper2("<C-f>", "<cmd> Telescope live_grep <CR>", "Find in tree selection", true)
maphelper2("<C-h>", vim.lsp.buf.hover, "LSP hover", true)
-- maphelper2("<C-f>", "<cmd> Telescope live_grep <CR>", "Find in tree selection", true)
-- maphelper2("<C-f>", funcs.live_grep_current_tree_selection, "Find in tree selection")
-- maphelper2("<C-b>", funcs.toggle_nvimtree, "Toggle tree")
--
-- maphelper2("<C-s>", funcs.smart_save, "Smart save")
-- maphelper2("<C-.>", function()
--   local options = vim.bo.ft == "NvimTree" and "nvimtree" or menuoptions
--   menu.open(options)
-- end, "Open menu")
--
-- -- mouse users + nvimtree users!
-- map("n", "<RightMouse>", function()
--   vim.cmd.exec('"normal! \\<RightMouse>"')
--
--   local options = vim.bo.ft == "NvimTree" and "nvimtree" or menuoptions
--   menu.open(options, { mouse = true })
-- end, {})
