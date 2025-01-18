return {
  -- {
  --   "Exafunction/codeium.nvim",
  --   cmd = "Codeium",
  --   event = "InsertEnter",
  --   build = ":Codeium Auth",
  --   -- enabled = false,
  --   opts = {
  --     virtual_text = {
  --       key_bindings = {
  --         accept = "<C-k>",
  --         next = "<C-l>",
  --         prev = "<C-j>",
  --         clear = "<C-i>",
  --       },
  --     },
  --   },
  -- },
  --

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
    opts = {
      provider = "copilot",
      hints = { enabled = false },
      -- behaviour = {
      --   auto_suggestions = true, -- Experimental stage
      -- },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts = {
      -- snippets = {},
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
        ["<esc>"] = {
          "cancel",
          "fallback",
        },

        cmdline = {
          preset = "super-tab",
          ["<CR>"] = { "accept", "fallback" },
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
        ghost_text = {
          enabled = false,
        },
        -- list = {
        --   selection = { preselect =  },
        -- },
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
    -- event = "VeryLazy",
    dependencies = { "saghen/blink.cmp" },

    opts = function(_, opts)
      opts.inlay_hints.enabled = true
      opts.diagnostics = vim.tbl_extend("keep", {
        update_in_insert = true,
        virtual_text = false,
      }, opts.diagnostics)

      opts.servers = vim.tbl_extend("keep", {
        dartls = {},
        emmet_ls = {},
        css_variables = { enabled = false },
        cssls = { enabled = false },
        somesass_ls = {},
        -- vala_ls = {},
        denols = { enabled = false },
      }, opts.servers)
      -- opts.setup = {
      --   capabilities =
      -- }
      for server, config in pairs(opts.servers) do
        opts.servers[server].capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
      end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    opts = { ensure_installed = { "dart" } },
  },

  {
    "nvim-flutter/flutter-tools.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    opts = {
      dev_log = {
        enabled = false,
        open_cmd = "botright 15split",
      },
      widget_guides = {
        enabled = false,
      },
      debugger = {
        enabled = true,
        exception_breakpoints = {},
        -- evaluate_to_string_in_debug_views = false,
        register_configurations = function(paths)
          require("dap.ext.vscode").load_launchjs()
        end,
      },
      lsp = {
        enabled = false,
        -- capabilities = function(config)
        --   return require("blink.cmp").get_lsp_capabilities(config)
        -- end,
        color = { -- show the derived colours for dart variables
          enabled = false, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
          -- background = false, -- highlight the background
          -- background_color = { r = 19, g = 17, b = 24 }, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
          -- foreground = false, -- highlight the foreground
          virtual_text = true, -- show the highlight using virtual text
          virtual_text_str = "■", -- the virtual text character to highlight
        },
      },
    },
  },
}
