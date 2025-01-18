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

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
  pattern = "*:n",
  callback = function()
    vim.lsp.inlay_hint.enable(true) -- disable hints in insert mode
  end,
})

vim.api.nvim_create_autocmd({ "ModeChanged" }, {
  pattern = "n:*",
  callback = function()
    vim.lsp.inlay_hint.enable(false) -- disable hints in insert mode
  end,
})
