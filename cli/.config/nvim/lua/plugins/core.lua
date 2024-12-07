return {
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = "catppuccin"
    end,
  },
  {
    "amitds1997/remote-nvim.nvim",
    version = "*", -- Pin to GitHub releases
    dependencies = {
      "nvim-lua/plenary.nvim", -- For standard functions
      "MunifTanjim/nui.nvim", -- To build the plugin UI
      "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    opts = {
      ssh_binary = "ssh", -- Binary to use for running SSH command
      scp_binary = "scp", -- Binary to use for running SSH copy commands
      ssh_config_file_paths = { "$HOME/.ssh/config" },
    },
  },
}
