-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
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

map("n", "<leader>ups", function()
  vim.cmd([[
		:profile start /tmp/nvim-profile.log
		:profile func *
		:profile file *
	]])
end, { desc = "Profile Start" })

map("n", "<leader>upe", function()
  vim.cmd([[
		:profile stop
		:e /tmp/nvim-profile.log
	]])
end, { desc = "Profile End" })

map("n", "<", function()
  funcs.blame_current_line()
end)

--
maphelper("<S-down>", "V<Down>", "<Down>", "<Esc>v<Down>", "Select line up")
maphelper("<S-up>", "V<Up>", "<Up>", "<Esc>v<Up>", "Select line down")
maphelper("<C-a>", "ggVG", "ggVG", "<Esc>ggVG<CR>", "Select all")
maphelper("<C-c>", "y", "y", "<Esc>y", "Copy")
maphelper("<C-z>", "u", "<esc>u", "<Esc>u", "Undo")
maphelper("<C-y>", ":redo<CR>", ":redo<CR>", "<Esc>:redo", "Redo")
-- -- clear highlighting
maphelper("<C-ö>", "gcc", "gc<cr>gv=gv", "<Esc>gcc<CR>i", "Toggle comment", true)
maphelper("<C-x>", "x", "x", "<Esc>x", "Cut selection", true)
maphelper(
  "<C-n>",
  ":ene | startinsert<CR>",
  ":ene | startinsert<CR>",
  "<Esc>:ene | startinsert<CR>",
  "New empty buffer",
  true
)
maphelper("<A-d>", "yyp", "yyp", "<Esc>yyp", "Duplicate line")
-- maphelper("<A-down>", ":m .+1<CR>==", ":'<,'>m '>+1<CR>gv=gv", "<Esc>:m .+1<CR>==gi", "Move line down")
-- maphelper("<A-up>", ":m .-2<CR>==", ":m '<-2<CR>gv=gv", "<Esc>:m .-2<CR>==gi", "Move line up")
maphelper("<A-up>", ":MoveLine(-1)<CR>", ":MoveBlock(-1)<CR>", "<nop>", "Move line up")
maphelper("<A-down>", ":MoveLine(1)<CR>", ":MoveBlock(1)<CR>", "<nop>", "Move line down")
--

map("v", "<BS>", '"_c', { remap = true })
map("n", "<BS>", "i<right><bs>", { remap = true })
map({ "n", "v" }, "d", '"_d')
map({ "n", "v" }, "D", '"_D')
map({ "n", "v" }, "c", '"_c')
map("n", "!", function()
  funcs.definition_in_float()
end)
map({ "n", "v", "i" }, "<A-g>", function()
  funcs.cycle_through_marks()
end)

map({ "n", "v", "i" }, "<A-u>", function()
  funcs.cycle_through_marks(true)
end)

-- map({ "n", "v" }, "f", "s", { remap = true })
-- map({ "n", "v" }, "s", "ys", { remap = true })

-- map("n", "?", "<cmd>WhichKey<cr>", { noremap = true, desc = "Show WhichKey" })

-- map({ "n", "v" }, "<space>t", function()
--   Snacks.terminal.toggle()
-- end, { desc = "Toggle terminal" })
map("n", "<leader>ga", "<cmd>Gitsigns blame<cr>", { desc = "Annotate with Git Blame" })
map({ "n", "v" }, "<S-ScrollWheelUp>", "10zl", { silent = true })
map({ "n", "v" }, "<S-ScrollWheelDown>", "10zh", { silent = true })

-- maphelper2("<esc>", "<C-c>", "Fix escape")
map("n", "?", function()
  vim.lsp.buf.hover()
end)
map("n", ">", vim.diagnostic.open_float)
map(
  "n",
  "<space>dh",
  ":lua print(vim.inspect(vim.treesitter.get_captures_at_cursor()))<cr>",
  { desc = "Show highlight info" }
)

if vim.g.neovide then
  maphelper("<C-S-V>", "P<CR>", "P<CR>", "<Esc>pa")
  map("c", "<C-S-V>", "<C-R>+")
  maphelper("<C-S-Z>", ":redo<cr>", ":redo<cr>", "<Esc>:redo<cr>")
  maphelper2("<C-+>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
  end)
  maphelper2("<C-->", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1 / 1.1
  end)
  maphelper2("<C-0>", function()
    vim.g.neovide_scale_factor = 1
  end)
end
maphelper("<S-Right>", "v<Right>", "<Right>", "<right><esc>v<Right>")
maphelper("<S-Left>", "v<Left>", "<Left>", "<esc>v<Left>")
maphelper("<S-Down>", "v<Down>", "<Down>", "<esc><Right>v<Down>")
maphelper("<S-Up>", "v<Up>", "<Up>", "<esc>v<Up>")
maphelper("<S-End>", "v$", "$", "<esc>v$")
maphelper("<S-Home>", "v^", "^", "<esc>v^")
maphelper("<Home>", "^", "^", "<esc>^i")

-- GitConflict
map("n", "<leader>gCo", "<cmd>GitConflictChooseOurs<cr>", { desc = "Choose Ours" })
map("n", "<leader>gCt", "<cmd>GitConflictChooseTheirs<cr>", { desc = "Choose Theirs" })
map("n", "<leader>gCb", "<cmd>GitConflictChooseBoth<cr>", { desc = "Choose Both" })
map("n", "<leader>gCn", "<cmd>GitConflictChooseNone<cr>", { desc = "Choose None" })
map("n", "<leaer>gCl", "<cmd>GitConflictChooseNextConflict<cr>", { desc = "Next" })
map("n", "<leader>gCj", "<cmd>GitConflictChoosePrevConflict<cr>", { desc = "Previous" })
map("n", "<leader>gCa", "<cmd>GitConflictListQf<cr>", { desc = "Show All" })
map("n", "<leader>fh", function()
  vim.cmd("DiffviewFileHistory % --no-merges")
end, { desc = "File history" })

map("n", "<tab>", "i<tab>")
map("v", "<tab>", ">gv")
map("v", "<S-tab>", "<gv")

--
-- -- Telescope
-- --
maphelper2("<C-.>", function()
  funcs.code_actions()
end, "Code actions")
maphelper2("<C-Space>", function()
  vim.lsp.buf.hover()
end, "Code actions")

-- maphelper2("<C-S-o>", function()
--   vim.cmd("Yazi")
--   -- funcs.open_dialog("dir", "Open folder")
-- end, "Open folder dialog")

-- yank with flash

maphelper2("<C-o>", function()
  vim.cmd("Yazi")
  -- funcs.open_dialog("file", "Open file")
end, "Open folder dialog")
-- TODO: test
maphelper2("<C-t>", function()
  Snacks.picker.todo_comments()
  -- funcs.open_dialog("file", "Open file")
end, "Open folder dialog")

maphelper2("<C-p>", function()
  funcs:pick_files() -- funcs:pick_files()
end, "Worktree files")
maphelper2("<C-u>", function()
  Snacks.picker.buffers({ title = "Buffers" })
end, "Buffers")
maphelper2("<C-s>", function()
  funcs.smart_save()
end, "Smart save")
maphelper2("<C-r>", function()
  Snacks.picker.recent({ title = "Recent files" })
end, "Recent files")

maphelper2("<C-d>", function()
  Snacks.picker.lsp_symbols({ title = "LSP Symbols" })
end, "LSP symbols")

maphelper2("<C-f>", function()
  funcs:toggle_search_replace("buffer")
end, "Search and replace")
maphelper2("<A-f>", function()
  funcs:toggle_search_replace("project")
end, "Search and replace in files", true)

map("n", "\\", function()
  funcs:live_grep()
end)

map("n", "<leader>/", function()
  Snacks.picker.search_history({ layout = { preset = "select" } })
end, { noremap = true })

map("n", "<leader>:", function()
  Snacks.picker.command_history({ layout = { preset = "select" } })
end, { noremap = true })

maphelper2("<C-h>", vim.lsp.buf.hover, "LSP hover", true)
map("n", "M", function()
  funcs.automark(false)
end)
map("n", "U", function()
  funcs.automark(true)
end)

map("n", "|", function()
  vim.cmd("vsplit")
end)
map("n", "&", function()
  vim.cmd("split")
end)
map("n", "dmö", function()
  funcs.delete_automarks(false)
end)

map("n", "dmÖ", function()
  funcs.delete_automarks(true)
end)

map("n", "<esc>", function()
  funcs:smart_close()
end, { buffer = false, noremap = true })

map("n", "<C-\\>", function()
  vim.cmd("terminal")
end, { desc = "Open terminal" })

maphelper("<A-q>", ":qa<CR>", ":qa<CR>", "<Esc>:qa<CR>", "Quit", true)
maphelper2("<C-w>", function()
  Snacks.bufdelete()
end, "Close current file")
maphelper2("<A-b>", function()
  vim.cmd("close")
end, "Close current file")

map("n", "€", function()
  funcs:toggle_tree()
end, { noremap = true })
maphelper2("<A-e>", function()
  funcs:toggle_tree()
end, "Toggle tree")
maphelper2("<A-r>", "<cmd>BufferLineCyclePrev<cr>", "Previous buffer", true)
maphelper2("<A-t>", "<cmd>BufferLineCycleNext<cr>", "Next buffer", true)
map("n", "<A-j>", "<C-W>h")
map("n", "<A-l>", "<C-W>l")
map("n", "<A-i>", "<C-W>k")
map("n", "<A-k>", "<C-W>j")
maphelper2("<A-v>", "<C-w>v", "Split window vertically", true)
maphelper2("<A-c>", "<C-w>s", "Split window", true)
maphelper2("<C-q>", "<cmd>copen<cr>", "Open quickfix", true)

map("n", "<leader>fi", function()
  funcs.show_file_info_popup()
end, { desc = "File info" })
