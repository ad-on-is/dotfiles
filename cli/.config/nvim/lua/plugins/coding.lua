local role_map = {
  user = "human",
  assistant = "assistant",
  system = "system",
}

local parse_messages = function(opts)
  local messages = {
    { role = "system", content = opts.system_prompt },
  }
  vim.iter(opts.messages):each(function(msg)
    table.insert(messages, { speaker = role_map[msg.role], text = msg.content })
  end)
  return messages
end

local parse_response = function(data_stream, event_state, opts)
  if event_state == "done" then
    opts.on_complete()
    return
  end

  if data_stream == nil or data_stream == "" then
    return
  end

  local json = vim.json.decode(data_stream)
  local delta = json.deltaText
  local stopReason = json.stopReason

  if stopReason == "end_turn" then
    return
  end

  opts.on_chunk(delta)
end

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
  -- {
  --   "stevearc/conform.nvim",
  --   opts = {
  --     formatters_by_ft = {
  --       css = { "css_beautify" },
  --       sass = { "css_beautify" },
  --       scss = { "css_beautify" },
  --       javascript = { "prettierd" },
  --       typescript = { "prettierd" },
  --
  --     },
  --   },
  -- },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
    opts = {
      provider = "ollama",
      auto_suggestions_provider = "ollama",
      hints = { enabled = false },
      vendors = {
        ollama = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://127.0.0.1:11434/v1",
          model = "deepseek-r1:8b",
        },
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-coder",
        },
        cody = {
          endpoint = "https://sourcegraph.com",
          -- model = "anthropic::2024-10-22::claude-3-5-sonnet-latest",
          api_key_name = "",
          parse_curl_args = function(opts, code_opts)
            local headers = {
              ["Content-Type"] = "application/json",
              ["Authorization"] = "token sgp_fd1b4edb60bf82b8_8acc06d25720c66c71755bc5c64ffc2a20a3535e",
            }

            return {
              url = opts.endpoint .. "/.api/completions/stream?api-version=2&client-name=web&client-version=0.0.1",
              timeout = 30000,
              insecure = false,
              headers = headers,
              body = vim.tbl_deep_extend("force", {
                model = opts.model,
                temperature = 0,
                topK = -1,
                topP = -1,
                maxTokensToSample = 4000,
                stream = true,
                messages = parse_messages(code_opts),
              }, {}),
            }
          end,
          parse_response = parse_response,
          parse_messages = parse_messages,
        },
      },
      behaviour = {
        auto_suggestions = false, -- Experimental stage
      },
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
