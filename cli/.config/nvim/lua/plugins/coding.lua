local role_map = {
  user = "human",
  assistant = "assistant",
  system = "system",
}

return {
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
    },
  },
  { "echasnovski/mini.comment", enabled = false },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
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
      },
      cmdline = {
        enabled = true,
        completion = {
          menu = {
            auto_show = true,
          },
        },
        sources = function()
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

        keymap = {
          preset = "super-tab",
          ["<CR>"] = { "select_accept_and_enter", "fallback" },
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
        list = {
          selection = { preselect = false, auto_insert = true },
        },
        -- trigger = {
        --   show_on_trigger_character = true,
        --   show_on_insert_on_trigger_character = false,
        -- },
        -- list = {
        --   selection = { preselect =  },
        -- },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        php_cs_fixer = {
          args = { "fix", "$FILENAME" },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        phpcs = {
          args = {
            "-q",
            "--report=json",
            "--standard=PSR12",
            -- "--exclude=PSR1.Classes.ClassDeclaration.MissingNamespace",
            "-", -- need `-` at the end for stdin support
          },
          --     args = {
          --       "--standard=Squiz",
          --     },
        },
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
        golangci_lint_ls = { enabled = false },
        bashls = {
          filetypes = { "sh", "bash", "zsh" },
        },
        emmet_language_server = {
          enabled = false,
          filetypes = {
            "css",
            "eruby",
            "html",
            "htmldjango",
            "javascriptreact",
            "less",
            "pug",
            "sass",
            "scss",
            "typescriptreact",
            "htmlangular",
            "vue",
          },
          init_options = { showSuggestionsAsSnippets = false },
        },
        emmet_ls = { enabled = false },
        css_variables = { enabled = false },
        cssls = {},
        somesass_ls = {},
        -- vala_ls = {},
        denols = { enabled = false },
        phpactor = {
          enabled = false,
        },
        intelephense = {
          -- enabled = false,
          root_dir = vim.fn.getcwd(),
          filetypes = { "php" },
          { files = { associations = { "*.php", "*.module", "*.inc" } } },
        },
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

  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function(opts)
      local dap = require("dap")
      vim.notify(vim.inspect(dap.configurations.php))
      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Adis: Listen for Xebug",
          port = 9001,
          -- env = {XDEBUG_TRIGGER = "PHPSTORM"}
        },
      }
    end,
  },
}
