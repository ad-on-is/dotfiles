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

local get_filtered_marks = function()
  local marks = vim.fn.getmarklist("%")

  for i = #marks, 1, -1 do
    local mark = marks[i]
    if
      mark.mark == "'["
      or mark.mark == "'."
      or mark.mark == "'\""
      or mark.mark == "''"
      or mark.mark == "']"
      or mark.mark == "'^"
    then
      table.remove(marks, i)
    else
    end
  end
  return marks
end

local M = {

  definition_in_float = function()
    local params = vim.lsp.util.make_position_params(0, "utf-8")
    vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, _, _)
      if not result or vim.tbl_isempty(result) then
        return
      end

      local location = result[1]
      local bufnr = vim.uri_to_bufnr(location.uri)
      vim.fn.bufload(bufnr)

      local win_id = vim.api.nvim_open_win(bufnr, true, {
        relative = "cursor",
        width = 80,
        height = 20,
        row = 1,
        col = 0,
        style = "minimal",
        border = "rounded",
      })

      vim.api.nvim_win_set_cursor(win_id, { location.range.start.line + 1, location.range.start.character })

      -- Close on <Esc>
      vim.keymap.set("n", "<Esc>", function()
        vim.cmd("close")
      end, { buffer = bufnr, nowait = true })
    end)
  end,

  delete_automarks = function()
    local marks = get_filtered_marks()
    for _, mark in ipairs(marks) do
      local m = mark.mark:sub(-1)
      vim.api.nvim_buf_del_mark(0, m)
    end
  end,

  automark = function()
    ms = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local marks = get_filtered_marks()
    local ct = 0
    for _, mark in ipairs(marks) do
      local m = mark.mark:sub(-1)
      local pos = string.find(ms, m)
      if pos and pos > ct then
        ct = pos
      end
    end

    local mark = ms:sub(ct + 1, ct + 1)
    vim.api.nvim_buf_set_mark(0, mark, vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_win_get_cursor(0)[2], {})
  end,

  cycle_through_marks = function()
    local marks = get_filtered_marks()

    for i = #marks, 1, -1 do
      local mark = marks[i]
      if
        mark.mark == "'["
        or mark.mark == "'."
        or mark.mark == "'\""
        or mark.mark == "''"
        or mark.mark == "']"
        or mark.mark == "'^"
      then
        table.remove(marks, i)
      else
      end
    end

    if #marks == 0 then
      return
    end

    -- Sort marks by line number
    table.sort(marks, function(a, b)
      return a.pos[2] < b.pos[2]
    end)

    local current_line = vim.fn.line(".")
    local next_mark = nil

    -- Find next mark after current line
    for _, mark in ipairs(marks) do
      if mark.pos[2] > current_line then
        next_mark = mark
        break
      end
    end

    -- If no mark found after current line, wrap to first mark
    next_mark = next_mark or marks[1]

    if next_mark then
      vim.cmd("normal! " .. next_mark.pos[2] .. "G" .. next_mark.pos[3] .. "|")
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
    local neo_tree_win = nil
    local main_win = nil
    local treeselection = ""
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
      if filetype == "neo-tree" then
        neo_tree_win = win
      else
        main_win = win
      end
    end
    if main_win and vim.api.nvim_get_current_win() == neo_tree_win then
      local sm = require("neo-tree.sources.manager")
      local state = sm:_get_all_states()[1]
      local node = state.tree:get_node()
      treeselection = node.path
      if node.type ~= "directory" then
        local parts = {}
        for part in treeselection:gmatch("[^/]+") do
          table.insert(parts, part)
        end
        table.remove(parts)
        treeselection = "/" .. table.concat(parts, "/")
      end

      vim.api.nvim_set_current_win(main_win)
    end
    local gf = require("grug-far")
    local paths = vim.fn.expand("%")
    if instance == "project" then
      -- wcc = ":vertical topleft split"
      paths = treeselection
    end
    local prefills = { paths = paths, flags = "--multiline" }
    if not gf.has_instance(instance) then
      gf.open({
        instanceName = instance,
        windowCreationCommand = "split",
        prefills = prefills,
      })
      -- vim.cmd("vertical resize 60%")
    else
      if gf.is_instance_open(instance) then
        gf.hide_instance(instance)
      else
        local inst = gf.get_instance(instance)
        if not inst then
          return
        end
        inst:update_input_values(prefills, true)
        inst:open()
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
      if client.name ~= "copilot" then
        num_client_names = num_client_names + 1
        buf_client_names[num_client_names] = client.name
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
