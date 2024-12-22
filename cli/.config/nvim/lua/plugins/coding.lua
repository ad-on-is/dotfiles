return {
  -- {
  --   "Exafunction/codeium.nvim",
  --   cmd = "Codeium",
  --   build = ":Codeium Auth",
  --   opts = {
  --     enable_cmp_source = false,
  --     virtual_text = {
  --       manual = false,
  --       enabled = true,
  --       map_keys = false,
  --       -- key_bindings = {
  --       -- accept = false, -- handled by nvim-cmp / blink.cmp
  --       -- next = "<M-]>",
  --       -- prev = "<M-[>",
  --       -- },
  --     },
  --   },
  -- },

  {
    "neovim/nvim-lspconfig",
    -- dependencies = { "saghen/blink.cmp" },
    opts = function(_, opts)
      local lspconfig = require("lspconfig")
      opts.diagnostics.update_in_insert = true
      opts.inlay_hints.enabled = false
      opts.servers = vim.tbl_deep_extend("force", opts.servers, { dartls = {} })
      -- local cfg = { capabilities = require("blink.cmp").get_lsp_capabilities() }
      lspconfig["dartls"].setup({})
      -- for server, config in pairs(opts.servers) do
      --   print(vim.inspect(lspconfig[server]))
      --   config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
      --   opts.servers[server].capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
      --   lspconfig[server].setup(config)
      -- end
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "dart" } },
  },
  {
    "nvim-flutter/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      {
        "nvim-telescope/telescope.nvim",
        opts = function(_, opts)
          local telescope = require("telescope")
          telescope.load_extension("flutter")
        end,
      },
    },
    opts = {
      dev_log = {
        open_cmd = "botright 15split",
      },
      widget_guides = {
        enabled = false,
      },
      lsp = {
        -- capabilities = function(config)
        --   return require("blink.cmp").get_lsp_capabilities(config)
        -- end,
        color = { -- show the derived colours for dart variables
          enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
          -- background = false, -- highlight the background
          -- background_color = { r = 19, g = 17, b = 24 }, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
          -- foreground = false, -- highlight the foreground
          virtual_text = true, -- show the highlight using virtual text
          virtual_text_str = "■", -- the virtual text character to highlight
        },
      },
    },
    config = true,
  },
}
