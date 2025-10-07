return {
  {
    "folke/snacks.nvim",
    opts = {

      picker = {
        -- jump = {
        --   reuse_win = true,
        -- },
        matcher = {
          history_bonus = true,
        },
        formatters = {
          file = {
            truncate = 1000,
          },
        },
      },
    },
  },
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

  {
    "saghen/blink.cmp",
    dependencies = {

      {
        "xzbdmw/colorful-menu.nvim",
        event = "VeryLazy",
        opts = {},
      },
    },
    opts = {
      appearance = {
        kind_icons = {
          Color = "●",
        },
      },
      sources = {
        per_filetype = {
          AvanteInput = nil,
        },
      },
      cmdline = {
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == "/" or type == "?" then return { "buffer" } end
          -- Commands
          if type == ":" or type == "@" then return { "cmdline" } end
          return { "path" }
        end,
      },
      completion = {
        menu = {
          draw = {
            columns = { { "kind_icon" }, { "label", gap = 1 }, { "source_name" } },
            components = {
              label = {
                width = { fill = true, max = 60 },
                text = function(ctx)
                  local highlights_info = require("colorful-menu").blink_highlights(ctx)
                  if highlights_info ~= nil then
                    -- Or you want to add more item to label
                    return highlights_info.label
                  else
                    return ctx.label
                  end
                end,
                highlight = function(ctx)
                  local highlights = {}
                  local highlights_info = require("colorful-menu").blink_highlights(ctx)
                  if highlights_info ~= nil then highlights = highlights_info.highlights end
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end
                  -- Do something else
                  return highlights
                end,
              },
            },
          },
        },
      },
    },
  },
}
