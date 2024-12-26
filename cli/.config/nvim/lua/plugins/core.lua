return {
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  { "alvan/vim-closetag" },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  { "folke/persistence.nvim", enabled = false },
  {
    "rmagatti/auto-session",
    lazy = false,
    config = true,
  },
  {
    "fedepujol/move.nvim",
    opts = {
      --- Config
    },
  },
  -- {
  --   "echasnovski/mini.move",
  --   event = "VeryLazy",
  --   opts = {},
  -- },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*", "!dart" },
      -- dart is handled by flutter-tools
      user_default_options = {
        mode = "virtualtext",
        always_update = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        css = true,
        tailwind = true,
        -- sass = { enable = true },
      },
    },
  },
  -- {
  --   "amitds1997/remote-nvim.nvim",
  --   version = "*", -- Pin to GitHub releases
  --   dependencies = {
  --     "nvim-lua/plenary.nvim", -- For standard functions
  --     "MunifTanjim/nui.nvim", -- To build the plugin UI
  --     -- "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
  --   },
  --   opts = {
  --     ssh_binary = "ssh", -- Binary to use for running SSH command
  --     scp_binary = "scp", -- Binary to use for running SSH copy commands
  --     ssh_config_file_paths = { "$HOME/.ssh/config" },
  --   },
  -- },
}
