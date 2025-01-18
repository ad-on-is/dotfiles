return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

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
    opts = {
      map_bs = false,
    },
    config = true,
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
}
