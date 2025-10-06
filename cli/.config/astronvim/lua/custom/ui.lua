return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      preset = "helix",
    },

    keys = {
      {
        "<leader>?",
        function() require("which-key").show { global = false } end,
        desc = "Buffer Keymaps (which-key)",
      },
      {
        "<c-w><space>",
        function() require("which-key").show { keys = "<c-w>", loop = true } end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "VeryLazy",
    opts = {
      filesystem = {
        filtered_items = {
          visible = false, -- hide filtered items on open
          hide_gitignored = true,
          hide_dotfiles = false,
          hide_by_name = {
            ".git",
            ".DS_Store",
            "thumbs.db",
          },
        },
      },
      close_if_last_window = true,
      default_component_configs = {
        name = { use_git_status_colors = false },
        modified = {
          symbol = " ",
        },
        git_status = {
          symbols = {
            unstaged = "",
            added = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
          },
        },
      },
    },
  },

  {
    "Isrothy/neominimap.nvim",
    init = function(plugin)
      vim.opt.sidescrolloff = 36 -- Set a large value

      vim.g.neominimap = {
        layout = "split",
        auto_enable = true,
        x_multiplier = 4,
        y_multiplier = 1,
        float = { minimap_width = 10, window_border = "none" },
        split = { minimap_width = 10 },
        click = { enabled = true },
      }
    end,
  },
}
