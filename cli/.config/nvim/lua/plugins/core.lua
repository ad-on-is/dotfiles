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
    opts = {
      -- auto_restore = false,
    },
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
  {
    "m00qek/baleia.nvim",
    version = "*",
    config = function()
      vim.g.baleia = require("baleia").setup({ async = false })
      vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        pattern = "*dap-repl*",
        callback = function()
          vim.g.baleia.automatically(vim.api.nvim_get_current_buf())
        end,
      })

      -- Command to colorize the current buffer
      vim.api.nvim_create_user_command("BaleiaColorize", function()
        vim.g.baleia.once(vim.api.nvim_get_current_buf())
      end, { bang = true })
      --
      -- -- Command to show logs
      -- vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
    end,
  },
}
