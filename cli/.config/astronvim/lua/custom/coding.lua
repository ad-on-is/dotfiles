return {

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
