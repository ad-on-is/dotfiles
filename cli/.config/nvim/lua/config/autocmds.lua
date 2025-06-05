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
--

local ignored_formatonsave_types = { "phtml" }
local funcs = require("config.functions")

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    local f = args.file
    local type = vim.fn.fnamemodify(f, ":e")

    if vim.fn.index(ignored_formatonsave_types, type) ~= -1 then
      return
    else
      require("conform").format({ bufnr = args.buf, async = true })
    end
  end,
})

-- vim.api.nvim_create_user_command("DiffFormat", function(args)
--   funcs.diff_format(args)
-- end, { desc = "Format changed lines" })

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
