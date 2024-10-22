local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{ "jose-elias-alvarez/null-ls.nvim", config = function() require "custom.configs.null-ls" end }
		 },
		config = function()
			require "plugins.configs.lspconfig"
			require "custom.configs.lspconfig"
		end -- Override to setup mason-lspconfig
	 },

	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
	 },

	{
		"mikesmithgh/kitty-scrollback.nvim",
		enabled = true,
		lazy = true,
		cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
		event = { "User KittyScrollbackLaunch" },
		-- version = '*', -- latest stable version, may have breaking changes if major version changed
		-- version = '^4.0.0', -- pin major version, include fixes and features that do not have breaking changes
		config = function() require( "kitty-scrollback" ).setup {} end
	 },

	-- override plugin configs
	{ "williamboman/mason.nvim", opts = overrides.mason },

	{ "nvim-treesitter/nvim-treesitter", opts = overrides.treesitter },

	{ "nvim-tree/nvim-tree.lua", opts = overrides.nvimtree },

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function() require( "better_escape" ).setup() end
	 },

	{ "alvan/vim-closetag" },

	{ "leafOfTree/vim-vue-plugin" }

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
 }

return plugins
