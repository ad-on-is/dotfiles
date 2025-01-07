-- local M = {}
--
-- M.code_actions = function(mouse)
--
--
-- end

return {

  code_actions = function()
    local function apply_specific_code_action(action_title)
      vim.lsp.buf.code_action({
        filter = function(action)
          return action.title == action_title
        end,
        apply = true,
      })
    end

    local actions = {}

    actions["Goto Definition"] = vim.lsp.buf.definition
    actions["Goto Implementation"] = vim.lsp.buf.implementation
    actions["Show References"] = vim.lsp.buf.references
    actions["Rename"] = vim.lsp.buf.rename

    local bufnr = vim.api.nvim_get_current_buf()
    local params = vim.lsp.util.make_range_params()

    params.context = {
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
      diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
    }

    vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(_, results, _, _)
      if not results or #results == 0 then
        return
      end
      for i, res in ipairs(results) do
        actions[res.title] = function()
          apply_specific_code_action("" .. res.title)
        end
      end
      local items = {}
      for t, _ in pairs(actions) do
        table.insert(items, t)
      end
      table.sort(items)
      vim.ui.select(items, {}, function(choice)
        if choice == nil then
          return
        end
        actions[choice]()
      end)
    end)
  end,

  toggle_tree = function()
    local neotree = require("neo-tree.command")
    if vim.bo.filetype == "neo-tree" then
      vim.cmd("wincmd p")
    else
      neotree.execute({ action = "focus" })
    end
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
