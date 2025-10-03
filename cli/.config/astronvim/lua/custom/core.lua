return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        myneotree = {
          {
          event = "VimEnter",
          callback = function()
  if vim.fn.argc() == 0 then vim.cmd "Neotree show" end
          end,
          }
        },
      },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = " <author> • <date> • <sha>",
      date_format = "%Y-%m-%d %H:%M",
      virtual_text_column = 1,
      display_virtual_text = 0,
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = {
      debounceMs = 200,
      minSearchChars = 1,
      resultLocation = {
        showNumberLabel = false,
      },
      previewWindow = {
        width = 3,
      },
    },
  },

  {
    "smoka7/multicursors.nvim",
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    opts = function(_, opts)
      local N = require "multicursors.normal_mode"

      return {
        normal_keys = {
          ["m"] = { method = N.create_char, opts = { desc = "Create char" } },
          ["M"] = { method = N.create_char, opts = { desc = "Create" } },
        },
        hint_config = {
          float_opts = {
            border = "rounded",
          },
          position = "bottom-right",
        },
        generate_hints = {
          normal = true,
          insert = true,
          extend = true,
          config = {
            column_count = 1,
          },
        },
      }
    end,
  },

  {
    "mikavilpas/yazi.nvim",
    keys = {
      { "<esc>", "q" },
    },
    opts = {
      hooks = {
        yazi_closed_successfully = function(chosen, config, state)
          if vim.fn.isdirectory(chosen) == 1 then
            vim.cmd("e " .. vim.fn.fnameescape(chosen))
            vim.cmd("cd " .. vim.fn.fnameescape(chosen))
            vim.cmd "SessionRestore"
          end
        end,
      },
    },
  },

  {
    "fedepujol/move.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      render = "virtual",
    },
  },

  {
    "rmagatti/auto-session",
    priority = 10000,
    specs = {
      { "resession.nvim", enabled = false },
    },
    opts = {},
  },

  -- colorize DAP output buffer
  {
    "m00qek/baleia.nvim",
    version = "*",
    event = "VeryLazy",
    specs = {

      {
        "AstroNvim/astrocore",
        opts = {
          autocmds = {
            colorize_dap_repl_output = {
              {
                event = "BufWinEnter",
                pattern = "*dap-repl*",
                callback = function() vim.g.baleia.automatically(vim.api.nvim_get_current_buf()) end,
              },
            },
          },
        },
      },
    },
    opts = {},
    -- config = function()
    --   vim.g.baleia = require("baleia").setup { async = false }
    --   vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    --     pattern = "*dap-repl*",
    --     callback = function() vim.g.baleia.automatically(vim.api.nvim_get_current_buf()) end,
    --   })
    --
    --   -- Command to colorize the current buffer
    --   vim.api.nvim_create_user_command(
    --     "BaleiaColorize",
    --     function() vim.g.baleia.once(vim.api.nvim_get_current_buf()) end,
    --     { bang = true }
    --   )
    --   --
    --   -- -- Command to show logs
    --   -- vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
    -- end,
  },

  {
    "saghen/blink.cmp",
    dependencies = { "archie-judd/blink-cmp-words" },
    opts = {
      sources = {
        providers = {
          thesaurus = {
            name = "Thesaurus",
            module = "blink-cmp-words.thesaurus",
            opts = {
              score_offset = 0,
              definition_pointers = { "!", "&", "^" },
              similarity_pointers = { "&", "^" },
              similarity_depth = 2,
            },
          },
          dictionary = {
            name = "Dictionary",
            module = "blink-cmp-words.dictionary",
            opts = {
              dictionary_search_threshold = 3,
              score_offset = 0,
              definition_pointers = { "!", "&", "^" },
            },
          },
        },
        per_filetype = {
          text = { "dictionary" },
          markdown = { "thesaurus" },
        },
      },
    },
  },
}
