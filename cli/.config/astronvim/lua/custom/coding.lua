return {
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
}
