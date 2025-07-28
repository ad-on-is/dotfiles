local funcs = require("config.functions")
local icons = LazyVim.config.icons

local git_blame = require("gitblame")

git_blame.is_blame_text_available() -- Returns a boolean value indicating whether blame message is available
git_blame.get_current_blame_text()

return {
  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        style = "minimal",
      },
      picker = {
        -- jump = {
        --   reuse_win = true,
        -- },
        formatters = {
          file = {
            truncate = 1000,
          },
        },
      },
      terminal = {},
      quickfile = {},
      bigfile = {
        size = 5 * 1024 * 1024, -- 5MB
      },
      scroll = {
        enabled = false,
      },
      statuscolumn = {
        folds = {
          open = true,
        },
      },
      indent = {
        enabled = false,
        animate = {
          enabled = false,
        },
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    opts = {
      winopts = {
        preview = {
          wrap = true,
        },
      },
    },
  },

  {
    "Isrothy/neominimap.nvim",
    init = function()
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
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▎" },
        topdelete = { text = "▎" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▎" },
        topdelete = { text = "▎" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
    },
  },
  {
    "xzbdmw/colorful-menu.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "saghen/blink.cmp",
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
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          -- Commands
          if type == ":" or type == "@" then
            return { "cmdline" }
          end
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
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      spec = {
        {
          { "<leader>/", group = "Search history", icon = { icon = " ", color = "blue" } },
        },
        {
          { "<leader>gC", group = "Conflict", icon = { icon = " ", color = "blue" } },
        },
        {
          { "<leader>a", group = "Avante", icon = { icon = "󰚩 ", color = "blue" } },
        },

        {
          { "<leader>up", group = "Profiler", icon = { icon = "󰾆 ", color = "green" } },
        },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
        -- indicator = { style = "underline" },
      },
    },
  },

  {
    "Bekaboo/dropbar.nvim",
    -- optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    opts = {
      -- bar = {
      --   truncate = false,
      -- },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "AndreM222/copilot-lualine" },
    },
    opts = {
      refresh = {
        statusline = 500,
        tabline = 500,
        winbar = 500,
      },
      sections = {
        lualine_b = {
          {
            "branch",
            fmt = function(str)
              if #str > 40 then
                local first = str:sub(1, 35)
                local last = str:sub(-5)
                return first .. "..." .. last
              end
              return str
            end,
          },
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
        },
        lualine_y = {
          "filetype",
          {
            funcs.get_attached_clients,
            -- color = {
            --   gui = "bold",
            -- },
          },
          "encoding",
          { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
        },
        lualine_z = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
          "searchcount",

          "copilot",
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    event = "VeryLazy",
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

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- notify = {
      --   enabled = false,
      -- },
      lsp = {
        hover = {
          silent = true,
        },

        -- signature = {
        --   enabled = false,
        -- },
      },

      cmdline = {
        format = {
          conceal = false,
        },
      },

      routes = {
        {
          view = "vsplit",
          filter = { event = "msg_show", min_height = 20 },
        },
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
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
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
    {
      "luukvbaal/statuscol.nvim",
      opts = {
        -- segments = {
        --   { text = "A" },
        -- },
      },
    },
    {
      "chentoast/marks.nvim",
      event = "VeryLazy",
      opts = {},
    },
    {
      "folke/trouble.nvim",
      opts = {
        auto_preview = false,
        focus = true,
        warn_no_results = false,
        open_no_results = true,
        keys = {
          ["<esc>"] = function()
            require("trouble").cancel()
            vim.cmd("Trouble qflist close")
          end,
        },
      },
      init = function()
        vim.api.nvim_create_autocmd("BufRead", {
          callback = function(ev)
            if require("trouble").is_open("qflist") then
              vim.cmd([[Trouble qflist close]])
            end

            if vim.bo[ev.buf].buftype == "quickfix" then
              vim.schedule(function()
                vim.cmd([[cclose]])
                vim.cmd([[Trouble qflist open]])
              end)
            end
          end,
        })
        -- vim.api.nvim_create_autocmd("BufWinEnter", {
        --   callback = function()
        --     if vim.bo.buftype == "quickfix" then
        --       vim.schedule(function()
        --         vim.cmd("cclose")
        --         require("trouble").open("qflist")
        --       end)
        --     end
        --   end,
        -- })
      end,
    },
    -- {
    --   "kevinhwang91/nvim-bqf",
    --   event = "FileType qf",
    --   opts = {},
    -- },
    {
      "shellRaining/hlchunk.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {
        chunk = { enable = true, delay = 0, chars = { right_arrow = "─" } },
        blank = { enable = true },
        -- indent = { enable = true },
      },
    },
  },
}
