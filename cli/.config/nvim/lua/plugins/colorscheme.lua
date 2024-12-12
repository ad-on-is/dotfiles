return {
  {
    "lukas-reineke/indent-blankline.nvim",
    -- main = "ibl",
    -- ---@module "ibl"
    -- ---@type ibl.config
    opts = function(_, opts)
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require("ibl.hooks")
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)
      vim.g.rainbow_delimiters = { highlight = highlight }
      opts.scope.highlight = highlight

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    dependencies = { "NvChad/base46" },
    opts = {
      flavour = "mocha",
      transparent_background = false,
      default_integations = true,
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        grug_far = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true, colored_indent_levels = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
      custom_highlights = function(C)
        local mix = require("base46.colors").mix
        local mc = function(fg, density)
          return mix(fg or C.surface2, C.crust, density or 80)
        end
        return {
          CmpItemMenu = { fg = C.surface2, italic = true },
          CmpItemKindSnippet = { fg = C.mauve, bg = mc(C.mauve) },
          CmpItemKindKeyword = { fg = C.red, bg = mc(C.red) },
          CmpItemKindText = { fg = C.teal, bg = mc(C.teal) },
          CmpItemKindMethod = { fg = C.blue, bg = mc(C.blue) },
          CmpItemKindConstructor = { fg = C.blue, bg = mc(C.blue) },
          CmpItemKindFunction = { fg = C.blue, bg = mc(C.blue) },
          CmpItemKindFolder = { fg = C.blue, bg = mc(C.blue) },
          CmpItemKindModule = { fg = C.blue, bg = mc(C.blue) },
          CmpItemKindConstant = { fg = C.peach, bg = mc(C.peach) },
          CmpItemKindField = { fg = C.green, bg = mc(C.green) },
          CmpItemKindProperty = { fg = C.green, bg = mc(C.green) },
          CmpItemKindEnum = { fg = C.green, bg = mc(C.green) },
          CmpItemKindUnit = { fg = C.green, bg = mc(C.green) },
          CmpItemKindClass = { fg = C.yellow, bg = mc(C.yellow) },
          CmpItemKindVariable = { fg = C.flamingo, bg = mc(C.flamingo) },
          CmpItemKindFile = { fg = C.blue, bg = mc(C.blue) },
          CmpItemKindInterface = { fg = C.yellow, bg = mc(C.yellow) },
          CmpItemKindColor = { fg = C.red, bg = mc(C.red) },
          CmpItemKindReference = { fg = C.red, bg = mc(C.red) },
          CmpItemKindEnumMember = { fg = C.red, bg = mc(C.red) },
          CmpItemKindStruct = { fg = C.blue, bg = mc(C.blue) },
          CmpItemKindValue = { fg = C.peach, bg = mc(C.peach) },
          CmpItemKindEvent = { fg = C.blue, bg = mc(C.blue) },
          CmpItemKindOperator = { fg = C.blue, bg = mc(C.blue) },
          CmpItemKindTypeParameter = { fg = C.blue, bg = mc(C.blue) },
          CmpItemKindCopilot = { fg = C.teal, bg = mc(C.teal) },
          CmpItemKindCodeium = { fg = C.teal, bg = mc(C.teal) },
          NeoTreeNormal = { fg = C.text, bg = "#10101a" },
          NeoTreeNormalNC = { fg = C.text, bg = "#10101a" },
          NeoTreeDirectoryName = { fg = C.text },
          NeoTreeDirectoryIcon = { fg = mc(C.blue, 60) },
          NeominimapBackground = { bg = "#10101a" },
        }
      end,
      color_overrides = {
        mocha = {
          crust = "#181825",
          surface0 = "#1e1e2e",
          base = "#11111b",
          mantle = "#11111b",
        },
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if (vim.g.colors_name or ""):find("catppuccin") then
            opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
          end
        end,
      },
    },
    lazy = false,
  },
}
