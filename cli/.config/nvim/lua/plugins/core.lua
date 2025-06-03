return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
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

  -- {
  --   "jake-stewart/multicursor.nvim",
  --   opts = {},
  -- },

  {
    "nvim-treesitter/nvim-treesitter",
    keys = {
      { "<bs>", false },
    },
    opts = {
      incremental_selection = {
        keymaps = {
          node_decremental = "<C-S-space>",
        },
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    enabled = false,
    opts = {
      map_bs = false,
    },
    config = true,
  },
  {
    "mikavilpas/yazi.nvim",
    opts = {},
  },

  {
    "rmagatti/auto-session",
    opts = {
      post_restore_cmds = {
        function()
          local close_timer = vim.loop.new_timer()

          if not close_timer then
            return
          end

          close_timer:start(
            100,
            0,
            vim.schedule_wrap(function()
              for i, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
                if buf.name == "" or buf.name == "[No Name]" then
                  Snacks.bufdelete(buf.bufnr)
                end
              end

              if close_timer then
                close_timer:stop()
                close_timer:close()
                close_timer = nil
              end
              vim.cmd(":wincmd p")
              vim.cmd(":GitConflictRefresh")
            end)
          )
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
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        virtualtext = "●",
        mode = "virtualtext",
        RRGGBBAA = true,
        AARRGGBB = true,
        css = true,
        virtualtext_inline = "after",
        tailwind = true,
        -- sass = { enable = true, parsers = { "css" } },
      },
    },
    init = function()
      local c = require("colorizer")
      vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
        callback = function(args)
          if args.event == "InsertEnter" then
            c.detach_from_buffer()
          else
            if not c.is_buffer_attached() then
              c.attach_to_buffer()
            end
          end
        end,
      })
    end,
  },

  {
    "m00qek/baleia.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      vim.g.baleia = require("baleia").setup({ async = false })
      vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        pattern = "*dap-repl*",
        callback = function()
          vim.g.baleia.automatically(vim.api.nvim_get_current_buf())
        end,
      })

      -- Command to colorize the current buffer
      vim.api.nvim_create_user_command("BaleiaColorize", function()
        vim.g.baleia.once(vim.api.nvim_get_current_buf())
      end, { bang = true })
      --
      -- -- Command to show logs
      -- vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
    end,
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      provider = "copilot",
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
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

  { "sindrets/diffview.nvim", opts = {} },
}
