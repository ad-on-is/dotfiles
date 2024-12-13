return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          { section = "header" },
          {
            pane = 2,
            section = "terminal",
            cmd = "colorscript -e square",
            height = 5,
            padding = 1,
          },
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git l -n 5",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
        preset = {
          header = [[
 ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗
 ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║
 ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║
 ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
 ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
 ]],
        },
      },
    },
  },
  {
    "Isrothy/neominimap.nvim",
    -- keys = {
    --   -- Global Minimap Controls
    --   { "<leader>nm", "<cmd>Neominimap toggle<cr>", desc = "Toggle global minimap" },
    --   { "<leader>no", "<cmd>Neominimap on<cr>", desc = "Enable global minimap" },
    --   { "<leader>nc", "<cmd>Neominimap off<cr>", desc = "Disable global minimap" },
    --   { "<leader>nr", "<cmd>Neominimap refresh<cr>", desc = "Refresh global minimap" },
    --
    --   -- Window-Specific Minimap Controls
    --   { "<leader>nwt", "<cmd>Neominimap winToggle<cr>", desc = "Toggle minimap for current window" },
    --   { "<leader>nwr", "<cmd>Neominimap winRefresh<cr>", desc = "Refresh minimap for current window" },
    --   { "<leader>nwo", "<cmd>Neominimap winOn<cr>", desc = "Enable minimap for current window" },
    --   { "<leader>nwc", "<cmd>Neominimap winOff<cr>", desc = "Disable minimap for current window" },
    --
    --   -- Tab-Specific Minimap Controls
    --   { "<leader>ntt", "<cmd>Neominimap tabToggle<cr>", desc = "Toggle minimap for current tab" },
    --   { "<leader>ntr", "<cmd>Neominimap tabRefresh<cr>", desc = "Refresh minimap for current tab" },
    --   { "<leader>nto", "<cmd>Neominimap tabOn<cr>", desc = "Enable minimap for current tab" },
    --   { "<leader>ntc", "<cmd>Neominimap tabOff<cr>", desc = "Disable minimap for current tab" },
    --
    --   -- Buffer-Specific Minimap Controls
    --   { "<leader>nbt", "<cmd>Neominimap bufToggle<cr>", desc = "Toggle minimap for current buffer" },
    --   { "<leader>nbr", "<cmd>Neominimap bufRefresh<cr>", desc = "Refresh minimap for current buffer" },
    --   { "<leader>nbo", "<cmd>Neominimap bufOn<cr>", desc = "Enable minimap for current buffer" },
    --   { "<leader>nbc", "<cmd>Neominimap bufOff<cr>", desc = "Disable minimap for current buffer" },
    --
    --   ---Focus Controls
    --   { "<leader>nf", "<cmd>Neominimap focus<cr>", desc = "Focus on minimap" },
    --   { "<leader>nu", "<cmd>Neominimap unfocus<cr>", desc = "Unfocus minimap" },
    --   { "<leader>ns", "<cmd>Neominimap toggleFocus<cr>", desc = "Switch focus on minimap" },
    -- },
    init = function()
      vim.opt.wrap = false
      vim.opt.sidescrolloff = 36 -- Set a large value

      vim.g.neominimap = {
        layout = "float",
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
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      window = { mappings = { ["<C-q>"] = ":qa!", ["<C-b>"] = ":wincmd p" } },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        custom_filter = function()
          return true
        end,
        indicator = { style = "underline" },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    -- dependencies = {
    --   { "nvim-lua/lsp-status.nvim" },
    -- },
    opts = {
      sections = {
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = {
              added = LazyVim.config.icons.git.added,
              modified = LazyVim.config.icons.git.modified,
              removed = LazyVim.config.icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_x = {
          "searchcount",
          "encoding",
          "filetype",
          {
            function()
              return "  " .. require("dap").status()
            end,
            cond = function()
              return package.loaded["dap"] and require("dap").status() ~= ""
            end,
            color = function()
              return LazyVim.ui.fg("Debug")
            end,
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return LazyVim.ui.fg("Special") end,
          },
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      if not opts.window then
        opts.window = { completion = { side_padding = 0 } }
      end
      local kind_icons = LazyVim.config.icons.kinds
      opts.formatting = {
        format = function(entry, item)
          item.menu = (item.kind or "Text") .. " [" .. entry.source.name .. "]"
          item.kind = (" " .. kind_icons[(item.kind or "Text")] .. " ") or " "
          return item
        end,
        fields = { "kind", "abbr", "menu" },
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local telescope = require("telescope")
      telescope.load_extension("flutter")

      opts.defaults.layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.60,
        },
        width = 0.90,
        height = 0.70,
      }
      opts.defaults.prompt_prefix = "   "
      opts.defaults.selection_caret = " "
      opts.defaults.entry_prefix = " "
      opts.defaults.sorting_strategy = "ascending"
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },

        signature = {
          enabled = false,
        },
      },

      cmdline = {
        format = {
          conceal = false,
        },
      },

      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "^/",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "No signature help",
          },
          opts = { skip = true },
        },

        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "Invalid mapping",
          },
          opts = { skip = true },
        },

        {
          filter = {
            event = "msg_show",
            kind = "emsg",
            find = "E486",
          },
          opts = { skip = true },
        },

        {
          filter = {
            event = "msg_show",
            kind = "emsg",
            find = "E16",
          },
          opts = { skip = true },
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
  },
}
