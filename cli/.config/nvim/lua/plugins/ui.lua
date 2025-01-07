local funcs = require("config.functions")
return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        enabled = false,
      },
      indent = {
        animate = {
          enabled = false,
        },
      },
      dashboard = {
        sections = {
          { section = "header" },
          { title = [[


          ]], pane = 2 },
          {
            pane = 2,
            section = "terminal",
            cmd = "colorscript -e square",
            padding = 1,
            height = 7,
          },
          { section = "keys", pane = 2, padding = 1, indent = 2 },
          { icon = " ", title = "Recent Files", section = "recent_files", padding = 1 },
          { icon = " ", title = "Projects", section = "projects", padding = 1 },
          {

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
	                                                                    
	       ████ ██████           █████      ██                    
	      ███████████             █████                            
	      █████████ ███████████████████ ███   ███████████  
	     █████████  ███    █████████████ █████ ██████████████  
	    █████████ ██████████ █████████ █████ █████ ████ █████  
	  ███████████ ███    ███ █████████ █████ █████ ████ █████ 
	 ██████  █████████████████████ ████ █████ █████ ████ ██████
 ]],
        },
      },
    },
  },
  -- {
  --   "Isrothy/neominimap.nvim",
  --   init = function()
  --     vim.opt.sidescrolloff = 36 -- Set a large value
  --
  --     vim.g.neominimap = {
  --       layout = "float",
  --       auto_enable = true,
  --       x_multiplier = 4,
  --       y_multiplier = 1,
  --       float = { minimap_width = 10, window_border = "none" },
  --       split = { minimap_width = 10 },
  --       click = { enabled = true },
  --     }
  --   end,
  -- },
  --
  {
    "xzbdmw/colorful-menu.nvim",
    config = true,
  },

  {
    "saghen/blink.cmp",
    opts = {
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
                  if highlights_info ~= nil then
                    highlights = highlights_info.highlights
                  end
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

  {
    "echasnovski/mini.map",
    lazy = false,
    config = function()
      local MiniMap = require("mini.map")
      MiniMap.setup({
        symbols = {
          encode = MiniMap.gen_encode_symbols.dot("3x2"),
        },
        integrations = {
          MiniMap.gen_integration.builtin_search(),
          MiniMap.gen_integration.diagnostic(),
          MiniMap.gen_integration.gitsigns(),
        },
        window = {
          focusable = true,
          show_integration_count = false,
          width = 8,
          winblend = 25,
        },
      })

      vim.api.nvim_create_autocmd("BufWinEnter", {
        callback = function()
          if vim.bo.filetype == "mninimap" then
            return
          else
            MiniMap = require("mini.map")
            MiniMap.open()
          end
        end,
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
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
      window = { mappings = { ["<A-q>"] = ":qa", ["<A-e>"] = ":wincmd p" } },
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
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      spec = {
        {
          { "<leader>gC", group = "Conflict", icon = { icon = " ", color = "blue" } },
        },
      },
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
          -- "nvim-dap-ui",
          "searchcount",
          -- LazyVim.lualine.cmp_source("codeium"),
          "encoding",
          "filetype",
          {
            funcs.get_attached_clients,
            color = {
              gui = "bold",
            },
          },
          {
            function()
              return "  " .. require("dap").status()
            end,
            cond = function()
              return package.loaded["dap"] and require("dap").status() ~= ""
            end,
            -- color = function()
            --   return Snacks.util.color("Debug")
            -- end,
          },
          -- stylua: ignore
          {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          --   color = function() return Snacks.util.color("Special") end,
          },
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      render_modes = true,
      code = {
        enabled = true,
      },
      heading = {
        enabled = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        signs = { "󰫎 " },
        left_pad = { 1, 2, 3, 4, 5, 6, 7, 8 },
      },
      checkbox = {
        enabled = true,
        position = "inline",
        unchecked = {
          icon = "󰄱 ",
        },
        checked = {
          icon = "󰱒 ",
        },
      },
    },
  },

  -- {
  --   "nvim-telescope/telescope.nvim",
  --   opts = function(_, opts)
  --     if not opts.defaults then
  --       opts.defaults = {}
  --     end
  --
  --     opts.defaults.layout_config = {
  --       horizontal = {
  --         prompt_position = "top",
  --         preview_width = 0.60,
  --       },
  --       width = 0.90,
  --       height = 0.70,
  --     }
  --     opts.defaults.prompt_prefix = "   "
  --     opts.defaults.selection_caret = " "
  --     opts.defaults.entry_prefix = " "
  --     opts.defaults.sorting_strategy = "ascending"
  --   end,
  -- },
  { "nvzone/volt", lazy = true },
  { "nvzone/menu", lazy = true },
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
            kind = "wmsg",
            find = "Invalid mapping",
          },
          opts = { skip = true },
        },

        {
          filter = {
            event = "msg_show",
            kind = "emsg",
            find = "Failed to set cursor",
          },
          opts = { skip = true },
        },

        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "Nothing is copied",
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
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      terminal = {
        -- your terminal configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "right",
          size = 25,
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.7,
            },
            {
              id = "console",
              size = 0.3,
            },
          },
          position = "bottom",
          size = 15,
        },
      },
    },
  },
}
