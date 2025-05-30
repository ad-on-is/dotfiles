-- local M = {}
--
-- M.code_actions = function(mouse)
--
--
-- end
--
local function scandir(directory)
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('ls -a "' .. directory .. '"')
  for filename in pfile:lines() do
    i = i + 1
    t[i] = filename
  end
  pfile:close()
  return t
end

local M = {

  -- diff_format = function(args)
  --   local hunks = require("gitsigns").get_hunks()
  --   local format = require("conform").format
  --   for i = #hunks, 1, -1 do
  --     local hunk = hunks[i]
  --     if hunk ~= nil and hunk.type ~= "delete" then
  --       local start = hunk.added.start
  --       local last = start + hunk.added.count
  --       -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
  --       local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
  --       local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
  --       format({ range = range })
  --     end
  --   end
  -- end,
  tree_search = function(self, type, state)
    local node = state.tree:get_node()
    local path = node.path

    if node.type ~= "directory" then
      -- vim.notify("Cannot " .. type .. " on a file")
      local parts = {}
      for part in path:gmatch("[^/]+") do
        table.insert(parts, part)
      end
      table.remove(parts)
      path = "/" .. table.concat(parts, "/")
      -- vim.notify(path)
      -- return
    end

    if type == "grep" then
      require("fzf-lua").live_grep({ cwd = path })
    else
      self:toggle_search_replace("project", path)
    end
  end,

  close_window = function()
    local buffers = {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      vim.notify(vim.inspect(vim.fn.getbufinfo(buf)))
      buffers[buf] = true
    end
    vim.notify("Visible buffers in this tab: " .. vim.tbl_count(buffers))
  end,

  open_dialog = function(type, title)
    -- vim.ui.input({ prompt = title .. ": " }, function(input)
    --   vim.notify(input)
    -- end)
    local target_dir = vim.fn.input(title .. ": ", vim.fn.getcwd() .. "/", type)
    if target_dir ~= "" then
      vim.cmd("e " .. vim.fn.fnameescape(target_dir))
      vim.cmd("cd " .. vim.fn.fnameescape(target_dir))
      vim.cmd("SessionRestore")
    end -- funcs.open_folder_dialog(nil, "/home")
  end,

  smart_close = function()
    local buftype = vim.bo.buftype

    local bts = { "nofile", "quickfix", "help", "terminal", "prompt" }

    for _, ft in ipairs(bts) do
      if buftype == ft then
        vim.cmd(":q")
        return
      end
    end
  end,

  toggle_search_replace = function(instance, path)
    local gf = require("grug-far")
    local p = path or ""
    vim.notify(p)
    if not gf.has_instance(instance) then
      local wcc = "vsplit"
      local paths = vim.fn.expand("%")
      if instance == "project" then
        wcc = ":vertical topleft split"
        paths = ""
      end
      gf.open({
        instanceName = instance,
        windowCreationCommand = wcc,
        prefills = { paths = paths, flags = "--multiline" },
      })
      vim.cmd("vertical resize 60%")
    else
      -- vim.notify(vim.inspect(i))
      if gf.is_instance_open(instance) then
        gf.hide_instance(instance)
      else
        gf.get_instance(instance):open()
        vim.cmd("vertical resize 60%")
      end
    end
  end,

  code_actions = function()
    local function apply_specific_code_action(res)
      -- vim.notify(vim.inspect(res))
      vim.lsp.buf.code_action({
        filter = function(action)
          return action.title == res.title
        end,
        apply = true,
      })
    end

    local actions = {}

    actions["Goto Definition"] = { priority = 100, call = vim.lsp.buf.definition }
    actions["Goto Implementation"] = { priority = 200, call = vim.lsp.buf.implementation }
    actions["Show References"] = { priority = 300, call = vim.lsp.buf.references }
    actions["Rename"] = { priority = 400, call = vim.lsp.buf.rename }

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
        local prio = 10
        if res.isPreferred then
          if res.kind == "quickfix" then
            prio = 0
          else
            prio = 1
          end
        end
        actions[res.title] = {
          priority = prio,
          call = function()
            apply_specific_code_action(res)
          end,
        }
      end
      local items = {}
      for t, action in pairs(actions) do
        table.insert(items, { title = t, priority = action.priority })
      end
      table.sort(items, function(a, b)
        return a.priority < b.priority
      end)
      local titles = {}
      for _, item in ipairs(items) do
        table.insert(titles, item.title)
      end
      vim.ui.select(titles, {}, function(choice)
        if choice == nil then
          return
        end
        actions[choice].call()
      end)
    end)
  end,

  toggle_tree = function()
    if vim.bo.filetype == "neo-tree" then
      vim.cmd("wincmd p")
    else
      -- Snacks.picker.explorer()
      local neotree = require("neo-tree.command")
      neotree.execute({ action = "focus" })
      vim.cmd("vertical resize 40%")
    end

    -- if vim.bo.filetype == "neo-tree" then
    --   vim.cmd("wincmd p")
    -- else
    --   neotree.execute({ action = "focus" })
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

    if vim.api.nvim_buf_get_name(0) == "" then
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

return M
