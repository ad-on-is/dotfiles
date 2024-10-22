---@type MappingsTable
local M = {}

local ts_select_dir_for_grep = function( prompt_bufnr )
	local action_state = require( "telescope.actions.state" )
	local fb = require( "telescope" ).extensions.file_browser
	local live_grep = require( "telescope.builtin" ).live_grep
	local current_line = action_state.get_current_line()

	fb.file_browser(
		{
			files = false,
			depth = false,
			attach_mappings = function( prompt_bufnr )
				require( "telescope.actions" ).select_default:replace(
					function()
						local entry_path = action_state.get_selected_entry().Path
						local dir = entry_path:is_dir() and entry_path or entry_path:parent()
						local relative = dir:make_relative( vim.fn.getcwd() )
						local absolute = dir:absolute()

						live_grep( { results_title = relative .. "/", cwd = absolute, default_text = current_line } )
					end
				 )

				return true
			end
		 }
	 )
end

M.general = {
	n = {
		["<C-c>"] = { "y", "Copy" },
		["<C-a>"] = { "ggVG", "Select all" },
		["<C-s>"] = { ":w<CR>", "Save" },
		["<C-x>"] = { ":x<CR>", "Save and exit" },
		["<C-q>"] = { ":q!<CR>", "Exit without saving" },
		["<A-d>"] = { "yyp", "Duplicate line" },
		["<A-k>"] = { ":m .+1<CR>==", "Move line down" },
		["<A-i>"] = { ":m .-2<CR>==", "Move line up" }
	 },
	v = {
		["<C-c>"] = { "y", "Copy" },
		["<C-a>"] = { "ggVG", "Select all" },
		["<C-s>"] = { ":w<CR>", "Save" },
		["<C-x>"] = { ":x<CR>", "Save and exit" },
		["<C-q>"] = { ":q!<CR>", "Exit without saving" },
		["<A-d>"] = { "yyp", "Duplicate line" },
		["<A-k>"] = { ":m '>+1<CR>gv=gv", "Move line down" },
		["<A-i>"] = { ":m '<-2<CR>gv=gv", "Move line up" }
	 },
	i = {
		["<C-c>"] = { "y", "Copy" },
		["<C-a>"] = { "<Esc>ggVG<CR>", "Select all" },
		["<C-s>"] = { "<Esc>:w<CR>", "Save" },
		["<C-x>"] = { "<Esc>:x<CR>", "Save and exit" },
		["<C-q>"] = { "<Esc>:q!<CR>", "Exit without saving" },
		["<A-d>"] = { "<Esc>:yyp<CR>", "Duplicate line" },
		["<A-k>"] = { "<Esc>:m .+1<CR>==gi", "Move line down" },
		["<A-i>"] = { "<Esc>:m .-2<CR>==gi", "Move line up" }
	 }
 }

M.telescope = {
	plugin = true,
	n = {
		["<C-p>"] = { "<cmd> Telescope find_files <CR>", "Worktree files" },
		["<C-r>"] = { "<cmd> Telescope oldfiles <CR>", "Recent files" },
		["<C-u>"] = { "<cmd> Telescope buffers <CR>", "Open files" },
		["<C-f>"] = { ts_select_dir_for_grep }
	 },
	v = {
		["<C-p>"] = { "<cmd> Telescope find_files <CR>", "Find files" },
		["<C-r>"] = { "<cmd> Telescope oldfiles <CR>" },
		["<C-u>"] = { "<cmd> Telescope buffers <CR>" },
		["<C-f>"] = { ts_select_dir_for_grep }
	 },
	i = {
		["<C-p>"] = { "<cmd> Telescope find_files <CR>", "Find files" },
		["<C-r>"] = { "<cmd> Telescope oldfiles <CR>" },
		["<C-u>"] = { "<cmd> Telescope buffers <CR>" },
		["<C-f>"] = { ts_select_dir_for_grep }
	 }
 }

M.nvimtree = {
	plugin = true,

	n = {
		-- toggle
		["<C-b>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },

		-- focus
		["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" }
	 }
 }

return M
