-- local M = {}
--
-- M.code_actions = function(mouse)
--
--
-- end

return {

  code_actions = function(mouse)
    local function apply_specific_code_action(action_title)
      vim.lsp.buf.code_action({
        filter = function(action)
          return action.title == action_title
        end,
        apply = true,
      })
    end
    local actions = {

      {
        name = "  Code Actions",
        hl = "Exgreen",
        items = {},
      },

      { name = "separator" },
      {
        name = "󰿨 Goto Definition",
        cmd = vim.lsp.buf.definition,
        hl = "Exwhite",
      },

      {
        name = " Goto Implementation",
        cmd = vim.lsp.buf.implementation,
        hl = "Exwhite",
      },
      {
        name = "󰵉 Show References",
        hl = "Exwhite",
        cmd = vim.lsp.buf.references,
      },
      { name = "separator" },
      {
        name = "󰑕 Rename",
        cmd = vim.lsp.buf.rename,
        hl = "Exyellow",
      },
    }

    local bufnr = vim.api.nvim_get_current_buf()
    local params = vim.lsp.util.make_range_params()

    params.context = {
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
      diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
    }

    local code_acts = {}
    vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(_, results, _, _)
      if #results > 0 then
        for i, res in ipairs(results) do
          code_acts[i] = {
            name = res.title,
            hl = "Exwhite",
            cmd = function()
              apply_specific_code_action(res.title)
            end,
          }
        end
        actions[1].items = code_acts
        require("menu").open(actions, { mouse = mouse or false })
      end
    end)
    -- os.execute("sleep " .. tonumber(0.1))

    -- local options = vim.bo.ft == "neo-tree" and "nvimtree" or "default"
    -- require("menu").open(options, { mouse = true })
    -- local actions = require("telescope.actions")
    -- local action_state = require("telescope.actions.state")
    --
    -- local lsp_actions = {
    --   { "  Code Actions \t\t\t\t\t\t ->", vim.lsp.buf.code_action },
    --   { "󰿨 Go to Definition", vim.lsp.buf.definition },
    --   { " Goto Implementation", vim.lsp.buf.implementation },
    --   { "󰮥 Show signature help", vim.lsp.buf.signature_help },
    --   { "󰵉 Show References", vim.lsp.buf.references },
    -- }
    --
    -- require("telescope.pickers")
    --   .new({}, {
    --     prompt_title = "LSP Actions",
    --     -- layout_strategy = "vertical",
    --     layout_config = {
    --       horizontal = {
    --         prompt_position = "top",
    --         -- preview_width = 0.60,
    --       },
    --       width = 30,
    --       height = 10,
    --     },
    --     finder = require("telescope.finders").new_table({
    --       results = lsp_actions,
    --       entry_maker = function(entry)
    --         return {
    --           value = entry[2],
    --           display = entry[1],
    --           ordinal = entry[1],
    --         }
    --       end,
    --     }),
    --     sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
    --     attach_mappings = function(prompt_bufnr, map)
    --       actions.select_default:replace(function()
    --         local selection = action_state.get_selected_entry()
    --         actions.close(prompt_bufnr)
    --         if selection then
    --           selection.value()
    --         end
    --       end)
    --       return true
    --     end,
    --   })
    --   :find()
  end,

  toggle_tree = function()
    local neotree = require("neo-tree.command")
    if vim.bo.filetype == "neo-tree" then
      vim.cmd("wincmd p")
    else
      neotree.execute({ action = "focus" })
    end
    -- local view = require("neo-tree.view")
    -- if view.is_visible() then
    --   if vim.api.nvim_get_current_win() == view.get_winnr() then
    --     -- Currently focused on nvim-tree, switch to other window
    --     vim.cmd("wincmd p")
    --   else
    --     -- Currently focused on other window, switch to nvim-tree
    --     view.focus()
    --   end
    -- else
    --   -- NvimTree not visible, open it
    --   require("nvim-tree.api").tree.open()
    -- end
  end,

  open_nvim_tree = function(data)
    local directory = vim.fn.isdirectory(data.file) == 1
    if not directory then
      return
    end
    vim.cmd.cd(data.file)
    require("nvim-tree.api").tree.open()
  end,

  smart_save = function()
    if vim.bo.filetype == "neo-tree" then
      return
    end

    if
      vim.api.nvim_buf_get_name(0) == ""
      or (vim.api.nvim_buf_line_count(0) == 1 and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == "")
    then
      local filename = vim.fn.input("Save file as: ")
      if filename ~= "" then
        vim.cmd("write " .. filename)
      end
    else
      -- Save existing file
      vim.cmd("write")
    end
  end,

  toggle_comment = function()
    require("Comment.api").call("comment.linewise.current", "g@$")
  end,

  move_block_vertically = function(direction)
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local last_line = vim.fn.line("$")

    if direction == "down" then
      if end_line < last_line then
        vim.cmd("normal! :m '>+1<CR>gv=gv")
      end
    elseif direction == "up" then
      if start_line > 1 then
        vim.cmd("normal! gv:move '<-2<CR>gv")
      end
    end
  end,

  restore_cursor_position = function()
    local line = vim.fn.line("'\"")
    if
      line > 1
      and line <= vim.fn.line("$")
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd('normal! g`"')
    end
  end,

  get_attached_clients = function()
    -- Get active clients for current buffer
    local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #buf_clients == 0 then
      return "LSP: inactive"
    end
    local buf_ft = vim.bo.filetype
    local buf_client_names = {}
    local buf_formater_names = {}
    local num_client_names = #buf_client_names

    -- Add lsp-clients active in the current buffer
    for _, client in pairs(buf_clients) do
      num_client_names = num_client_names + 1
      buf_client_names[num_client_names] = client.name
    end

    -- Add linters for the current filetype (nvim-lint)
    local lint_success, lint = pcall(require, "lint")
    if lint_success then
      for ft, ft_linters in pairs(lint.linters_by_ft) do
        if ft == buf_ft then
          if type(ft_linters) == "table" then
            for _, linter in pairs(ft_linters) do
              num_client_names = num_client_names + 1
              buf_client_names[num_client_names] = linter
            end
          else
            num_client_names = num_client_names + 1
            buf_client_names[num_client_names] = ft_linters
          end
        end
      end
    end

    local conform_success, conform = pcall(require, "conform")
    if conform_success then
      for _, formatter in pairs(conform.list_formatters_for_buffer(0)) do
        if formatter then
          num_client_names = num_client_names + 1
          buf_client_names[num_client_names] = formatter
        end
      end
    end

    local client_names_str = table.concat(buf_client_names, ", ")
    local language_servers = string.format("LSP: %s", client_names_str)

    return language_servers
  end,
}
