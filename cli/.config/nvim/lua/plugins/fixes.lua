return {
  {
    "ibhagwan/fzf-lua",
    enabled = false,
    opts = {
      winopts = {
        on_create = function(_)
          vim.api.nvim_create_autocmd("ModeChanged", {
            once = true,
            buffer = 0,
            callback = function(e)
              if e.match:match(":nt") then
                vim.defer_fn(function()
                  if vim.api.nvim_buf_is_valid(e.buf) and vim.api.nvim_get_mode().mode ~= "t" then
                    vim.cmd("startinsert")
                  end
                end, 0)
              end
            end,
          })
        end,
      },
    },
    -- opts = function(_, opts)
    --   opts.winopts.on_create = function(_)
    --     vim.api.nvim_create_autocmd("ModeChanged", {
    --       once = true,
    --       buffer = 0,
    --       callback = function(e)
    --         if e.match:match(":nt") then
    --           vim.defer_fn(function()
    --             if vim.api.nvim_buf_is_valid(e.buf) and vim.api.nvim_get_mode().mode ~= "t" then
    --               vim.cmd("startinsert")
    --             end
    --           end, 0)
    --         end
    --       end,
    --     })
    --   end
    -- end,
  },
}
