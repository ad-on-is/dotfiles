return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
        cmdline = {
          preset = "super-tab",
          ["<esc>"] = {
            "cancel",
            function()
              if vim.fn.getcmdtype() ~= "" then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", true)
                return
              end
            end,
          },
        },
      },
      completion = {
        accept = { auto_brackets = { enabled = false } },
        list = {
          selection = "auto_insert",
        },
        menu = {
          scrollbar = false,
          draw = {
            padding = { 0, 1 },
            columns = { { "kind_icon" }, { "label", "label_description", "source_name", gap = 2 } },
          },
        },
      },
      sources = {
        cmdline = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          -- Commands
          if type == ":" then
            return { "cmdline" }
          end
          return {}
        end,
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    opts = function(_, opts)
      local lspconfig = require("lspconfig")
      opts.diagnostics.update_in_insert = true
      opts.diagnostics.virtual_text = false
      opts.inlay_hints.enabled = false
      opts.servers = vim.tbl_deep_extend("force", opts.servers, { dartls = {} })
      local cfg = { capabilities = require("blink.cmp").get_lsp_capabilities() }
      lspconfig["dartls"].setup(cfg)
      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        opts.servers[server].capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        -- lspconfig[server].setup(config)
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "dart" } },
  },
  {
    "nvim-flutter/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      {
        "nvim-telescope/telescope.nvim",
        opts = function(_, opts)
          local telescope = require("telescope")
          telescope.load_extension("flutter")
        end,
      },
    },
    opts = {
      dev_log = {
        open_cmd = "botright 15split",
      },
      widget_guides = {
        enabled = false,
      },
      lsp = {
        -- capabilities = function(config)
        --   return require("blink.cmp").get_lsp_capabilities(config)
        -- end,
        color = { -- show the derived colours for dart variables
          enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
          -- background = false, -- highlight the background
          -- background_color = { r = 19, g = 17, b = 24 }, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
          -- foreground = false, -- highlight the foreground
          virtual_text = true, -- show the highlight using virtual text
          virtual_text_str = "■", -- the virtual text character to highlight
        },
      },
    },
    config = true,
  },
}
