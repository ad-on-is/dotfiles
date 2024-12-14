return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-cmdline",
    "dmitmel/cmp-cmdline-history",
    "hrsh7th/cmp-path",
  },

  opts = function(_, opts)
    local cmp = require("cmp")
    local cmdmapping = cmp.mapping.preset.cmdline()
    cmdmapping["<Down>"] = cmdmapping["<Tab>"]
    cmdmapping["<Up>"] = cmdmapping["<S-Tab>"]
    cmdmapping["<CR>"] =
      cmp.mapping(cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }), { "i", "c" })
    local searchmapping = cmp.mapping.preset.cmdline()
    searchmapping["<Down>"] = searchmapping["<Tab>"]
    searchmapping["<Up>"] = searchmapping["<S-Tab>"]
    cmp.setup.cmdline("/", {
      mapping = searchmapping,
      sources = {
        { name = "buffer" },
      },
    })
    cmp.setup.cmdline(":", {
      mapping = cmdmapping,
      sources = cmp.config.sources({
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
        { name = "cmdline_history" },
      }),
    })

    opts.mapping["<Esc>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        -- If completion menu is open, close it
        cmp.close()
      else
        -- If no completion menu, fall back to default Escape behavior
        fallback()
      end
    end, { "i", "s" })

    opts.completion = {
      completeopt = "menu,menuone,noinsert",
    }
    opts.preselect = cmp.PreselectMode.None

    opts.sorting = {
      -- priority_weight = 2,
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        -- cmp.config.compare.scopes,
        cmp.config.compare.kind,
        cmp.config.compare.recently_used,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    }

    -- SUPERTAB
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
          cmp.select_next_item()
        elseif vim.snippet.active({ direction = 1 }) then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.snippet.active({ direction = -1 }) then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
        else
          fallback()
        end
      end, { "i", "s" }),
    })
  end,
  lazy = false, -- dont lazy load, otherwise / and : won't work
}
