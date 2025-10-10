return {

  {
    "yarospace/dev-tools.nvim",

    opts = {
      ---@type Action[]|fun():Action[]
      actions = {

        {
          name = "Go to definition",
          fn = function(_) vim.lsp.buf.definition() end,
        },
        {
          name = "Go to implementation",
          fn = function(_) vim.lsp.buf.implementation() end,
        },
        {
          name = "Show references",
          fn = function(_) vim.lsp.buf.references() end,
        },
        {
          name = "Rename",
          fn = function(_) vim.lsp.buf.rename() end,
        },
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "intelephense" })
    end,
  },

  {

    "kylechui/nvim-surround",
    specs = {},
    opts = {},
  },


{
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
      formatters = {
        php_cs_fixer = {
          args = { "fix", "$FILENAME" },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
      formatters = {
        php_cs_fixer = {
          args = { "fix", "$FILENAME" },
        },
      },
    },
  },
}
