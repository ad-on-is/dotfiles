return {
  { "folke/persistence.nvim", enabled = false },
  {
    "nvim-mini/mini.pairs",
    enabled = false,
  },
  { "nvim-mini/mini.comment", enabled = false },

  { "roobert/tailwindcss-colorizer-cmp.nvim", enabled = false },
  { "rafamadriz/friendly-snippets", enabled = false },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {

      routes = {
        {
          filter = {
            event = "notify",
            find = "Request textDocument/inlayHint failed",
          },
          opts = { skip = true },
        },
        {
          view = "vsplit",
          filter = { event = "msg_show", min_height = 20 },
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "^/",
          },
          opts = { skip = true },
        },

        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "Nothing is copied",
          },
          opts = { skip = true },
        },

        {
          filter = {
            event = "msg_show",
            kind = "emsg",
            find = "E486",
          },
          opts = { skip = true },
        },

        {
          filter = {
            event = "msg_show",
            kind = "emsg",
            find = "E16",
          },
          opts = { skip = true },
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    },
  },
}
