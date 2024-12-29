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
maphelper("<C-x>", "x", "x", "<Esc>x", "Cut selection", true)
maphelper("<C-n>", ":ene | startinsert<CR>", ":ene | startinsert<CR>", "<Esc>:ene | startinsert<CR>", "Quit", true)
maphelper("<A-d>", "yyp", "yyp", "<Esc>yyp", "Duplicate line")
-- maphelper("<A-down>", ":m .+1<CR>==", ":'<,'>m '>+1<CR>gv=gv", "<Esc>:m .+1<CR>==gi", "Move line down")
-- maphelper("<A-up>", ":m .-2<CR>==", ":m '<-2<CR>gv=gv", "<Esc>:m .-2<CR>==gi", "Move line up")
maphelper("<A-up>", ":MoveLine(-1)<CR>", ":MoveBlock(-1)<CR>", "<nop>", "Move line up")
maphelper("<A-down>", ":MoveLine(1)<CR>", ":MoveBlock(1)<CR>", "<nop>", "Move line down")
--
map("n", "d", '"_d')
map("v", "d", '"_d')

map({ "n", "v" }, "<space>t", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle terminal" })

map("n", "<S-ScrollWheelUp>", "10zl", { silent = true })
map("n", "<S-ScrollWheelDown>", "10zh", { silent = true })

-- maphelper2("<esc>", "<C-c>", "Fix escape")
map("n", "c", '"_c')
map("n", "?", vim.diagnostic.open_float)
map(
  "n",
  "<space>dh",
  ":lua print(vim.inspect(vim.treesitter.get_captures_at_cursor()))<cr>",
  { desc = "Show highlight info" }
)
map("v", "c", '"_c')
map("i", "jj", "jj")

if vim.g.neovide then
  maphelper("<C-S-V>", "P<CR>", "P<CR>", "<Esc>pli")
  map("c", "<C-S-V>", "<C-R>+")
  maphelper("<C-S-Z>", ":redo<cr>", ":redo<cr>", "<Esc>:redo<cr>")
end
map("n", "<S-Right>", "v<Right>", { noremap = true, silent = true })
map("n", "<S-Left>", "v<Left>", { noremap = true, silent = true })
map("v", "<S-Right>", "<Right>", { noremap = true, silent = true })
map("v", "<S-Left>", "<Left>", { noremap = true, silent = true })
map("i", "<S-Right>", "<C-o>v<Right>", { noremap = true, silent = true })
map("i", "<S-Left>", "<C-o>v<Left>", { noremap = true, silent = true })
map("n", "<S-End>", "v$", { noremap = true, silent = true })
map("v", "<S-End>", "$", { noremap = true, silent = true })
map("i", "<S-End>", "<esc>v$", { noremap = true, silent = true })

map("n", "<BS>", "xi", { noremap = true, silent = true })
map("x", "<BS>", "xi", { noremap = true, silent = true })
--
-- GitConflict
map("n", "<leader>gCo", "<cmd>GitConflictChooseOurs<cr>", { desc = "Choose Ours" })
map("n", "<leader>gCt", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Choose Theirs" })
map("n", "<leader>gCb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Choose Both" })
map("n", "<leader>gCn", "<cmd>GitConflictChooseNone<cr>", { desc = "Choose None" })
map("n", "<leader>gCl", "<cmd>GitConflictChooseNextConflict<cr>", { desc = "Next" })
map("n", "<leader>gCj", "<cmd>GitConflictChoosePrevConflict<cr>", { desc = "Previous" })
map("n", "<leader>gCa", "<cmd>GitConflictListQf<cr>", { desc = "Show All" })

--
-- -- Telescope
-- --
maphelper2("<C-.>", function()
  funcs.code_actions()
end, "Code actions")
maphelper2("<C-Space>", function()
  vim.lsp.buf.hover()
end, "Code actions")

maphelper2("<C-p>", "<cmd> FzfLua files <CR>", "Worktree files")
maphelper2("<C-u>", "<cmd> FzfLua buffers <CR>", "Used files")
maphelper2("<C-s>", function()
  funcs.smart_save()
end, "Smart save")
maphelper2("<C-r>", "<cmd> FzfLua oldfiles <CR>", "Recent files")
maphelper2("<C-f>", "<cmd> FzfLua live_grep_glob <CR>", "Life grep", true)
maphelper2("<C-h>", vim.lsp.buf.hover, "LSP hover", true)

maphelper("<A-q>", ":qa<CR>", ":qa<CR>", "<Esc>:qa<CR>", "Quit", true)
maphelper2("<A-b>", function()
  Snacks.bufdelete()
end, "Close current file")
maphelper2("<A-e>", funcs.toggle_tree, "Toggle tree")
maphelper2("<A-h>", "<cmd>BufferLineCyclePrev<cr>", "Previous buffer", true)
maphelper2("<A-ö>", "<cmd>BufferLineCycleNext<cr>", "Previous buffer", true)
maphelper2("<A-j>", "<C-w>h", "Go to left window", true)
maphelper2("<A-l>", "<C-w>l", "Go to right window", true)
maphelper2("<A-i>", "<C-w>k", "Go to top window", true)
maphelper2("<A-k>", "<C-w>j", "Go to bottom window", true)
maphelper2("<A-v>", "<C-w>v", "Split window vertically", true)
maphelper2("<A-c>", "<C-w>s", "Split window", true)
-- maphelper2("<A-x>", "<C-w>q", "Go to bottom window", true)
-- map("n", "<RightMouse>", function()
--   vim.cmd.exec('"normal! \\<RightMouse>"')
--
--   -- local options = vim.bo.ft == "NvimTree" and "nvimtree" or menuoptions
--   -- menu.open(options, { mouse = true })
--   funcs.code_actions(true)
-- end, {})
