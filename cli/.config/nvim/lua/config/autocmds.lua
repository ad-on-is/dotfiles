-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
-- vim.api.nvim_create_autocmd("CursorHold", {
--   callback = function()
--     vim.defer_fn(function()
--       vim.lsp.buf.hover()
--     end, 2000)
--   end,
-- })
--
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

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = "*dap-repl*",
  callback = function()
    local baleia = require("baleia").setup({})
    baleia.automatically(vim.api.nvim_get_current_buf())
  end,
})
