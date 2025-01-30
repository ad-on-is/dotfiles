return {
  { "rose-pine/neovim", name = "rose-pine", opts = {} },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = "catppuccin"
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = false,
      default_integations = true,
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        blink_cmp = true,
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
        fzf = true,
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
      custom_highlights = function(C, O)
        local mix = require("catppuccin.utils.colors").blend
        local mc = function(fg, density)
          return mix(fg or C.surface2, "#0e0f16", density or 0.1)
        end
        return {
          Comment = { fg = mc(C.lavender, 0.5) },
          DiagnosticUnnecessary = { style = { "undercurl" } },
          String = { fg = C.rosewater },
          ["@variable.parameter"] = { fg = C.mauve },
          ["@parameter"] = { fg = C.mauve },
          Keyword = { fg = C.sapphire },
          ["@keyword.operator"] = { fg = C.sapphire },
          LspInlayHint = { fg = mc(C.mauve, 0.5), bg = "none", style = { "italic" } },
          -- Operator = { fg = "#df8e1d" },
          Operator = { fg = "#e64553" },
          BlinkCmpMenu = { bg = "#0e0f16" },
          CursorLineNr = { fg = C.peach },
          BlinkCmpMenuSelection = { bg = mc(C.text) },
          BlinkCmpKindSnippet = { fg = C.mauve, bg = mc(C.mauve) },
          BlinkCmpKindKeyword = { fg = C.red, bg = mc(C.red) },
          BlinkCmpKindText = { fg = C.teal, bg = mc(C.teal) },
          BlinkCmpKindMethod = { fg = C.blue, bg = mc(C.blue) },
          BlinkCmpKindConstructor = { fg = C.blue, bg = mc(C.blue) },
          BlinkCmpKindFunction = { fg = C.blue, bg = mc(C.blue) },
          BlinkCmpKindFolder = { fg = C.blue, bg = mc(C.blue) },
          BlinkCmpKindModule = { fg = C.blue, bg = mc(C.blue) },
          BlinkCmpKindConstant = { fg = C.peach, bg = mc(C.peach) },
          BlinkCmpKindField = { fg = C.green, bg = mc(C.green) },
          BlinkCmpKindProperty = { fg = C.green, bg = mc(C.green) },
          BlinkCmpKindEnum = { fg = C.green, bg = mc(C.green) },
          BlinkCmpKindUnit = { fg = C.green, bg = mc(C.green) },
          BlinkCmpKindClass = { fg = C.yellow, bg = mc(C.yellow) },
          BlinkCmpKindVariable = { fg = C.flamingo, bg = mc(C.flamingo) },
          BlinkCmpKindFile = { fg = C.blue, bg = mc(C.blue) },
          BlinkCmpKindInterface = { fg = C.yellow, bg = mc(C.yellow) },
          BlinkCmpKindColor = { fg = C.red, bg = mc(C.red) },
          BlinkCmpKindReference = { fg = C.red, bg = mc(C.red) },
          BlinkCmpKindEnumMember = { fg = C.red, bg = mc(C.red) },
          BlinkCmpKindStruct = { fg = C.blue, bg = mc(C.blue) },
          BlinkCmpKindValue = { fg = C.peach, bg = mc(C.peach) },
          BlinkCmpKindEvent = { fg = C.blue, bg = mc(C.blue) },
          BlinkCmpKindOperator = { fg = C.blue, bg = mc(C.blue) },
          BlinkCmpKindTypeParameter = { fg = C.blue, bg = mc(C.blue) },
          BlinkCmpKindCopilot = { fg = C.teal, bg = mc(C.teal) },
          BlinkCmpKindCodeium = { fg = C.teal, bg = mc(C.teal) },
          NeoTreeNormal = { fg = C.text, bg = "#0e0f16" },
          NeoTreeNormalNC = { fg = C.text, bg = "#0e0f16" },
          NeoTreeDirectoryName = { fg = C.text },
          NeoTreeDirectoryIcon = { fg = mc(C.blue, 0.4) },
          NeominimapBackground = { bg = "#0e0f16" },
          NeominimapCursorLine = { bg = C.surface1 },
          SnacksIndent = { fg = C.crust },
          SnacksIndentScope = { fg = mc(C.lavender, 0.3) },
          SnacksIndentChunk = { fg = mc(C.lavender, 0.3) },
        }
      end,
      color_overrides = {
        mocha = {
          -- rosewater = "#efc9c2",
          -- flamingo = "#ebb2b2",
          -- pink = "#f2a7de",
          -- mauve = "#b889f4",
          -- red = "#ea7183",
          -- maroon = "#ea838c",
          -- peach = "#f39967",
          -- yellow = "#eaca89",
          -- green = "#96d382",
          -- teal = "#78cec1",
          -- sky = "#91d7e3",
          -- sapphire = "#68bae0",
          -- blue = "#739df2",
          -- lavender = "#a0a8f6",
          -- text = "#b5c1f1",
          -- subtext1 = "#a6b0d8",
          -- subtext0 = "#959ec2",
          -- overlay2 = "#848cad",
          -- overlay1 = "#717997",
          -- overlay0 = "#63677f",
          -- surface2 = "#505469",
          -- surface1 = "#3e4255",
          -- surface0 = "#2c2f40",

          -- base = "#1a1c2a",
          -- mantle = "#141620",
          -- crust = "#0e0f16",

          -- base = "#0e0f16",
          -- mantle = "#141620",
          -- crust = "#0e0f16",

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
  { "rasulomaroff/reactive.nvim", opts = { load = { "catppuccin-mocha-cursorline", "catppuccin-mocha-cursor" } } },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      lazygit = {
        configure = true,
        config = {
          os = { editPreset = "nvim-remote" },
          gui = {
            authorColors = {
              ["'*'"] = "#b4befe",
            },
            -- set to an empty string "" to disable icons
          },
        },
        theme_path = vim.fs.normalize("/home/adonis/.config/lazygit/catppuccin.yml"),
      },
    },
  },
}
