local get_filtered_marks = function(global)
  local marks = global and vim.fn.getmarklist() or vim.fn.getmarklist("%")
  local regex = global and "[A-Z]" or "[a-z]"
  for i = #marks, 1, -1 do
    local m = marks[i].mark:sub(-1)
    if not m:match(regex) then
      table.remove(marks, i)
    end
  end

  return marks
end

local function arrayHas(array, value)
  for _, a in ipairs(array) do
    if a == value then
      return true
    end
  end
  return false
end

local function findIndex(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil -- not found
end

local deleted_marks = {}
local deleted_marks_global = {}

local function bytes_to_human(bytes)
  local units = { "B", "KB", "MB", "GB", "TB", "PB" }
  local size = bytes
  local unit_index = 1

  while size >= 1024 and unit_index < #units do
    size = size / 1024
    unit_index = unit_index + 1
  end

  if unit_index == 1 then
    return string.format("%d %s", size, units[unit_index])
  else
    return string.format("%.1f %s", size, units[unit_index])
  end
end

local M = {

  blame_current_line = function()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local file = vim.api.nvim_buf_get_name(0)
    local relative_file = vim.fn.fnamemodify(file, ":.")

    -- Get detailed blame info
    local blame_cmd = string.format("git blame -L %d,%d --porcelain %s", line, line, file)
    local blame_result = vim.fn.system(blame_cmd)

    if vim.v.shell_error ~= 0 then
      vim.notify("Git blame failed: " .. blame_result, vim.log.levels.ERROR)
      return
    end

    -- Parse porcelain format
    local lines = vim.split(blame_result, "\n")
    local commit_hash = lines[1]:match("^(%w+)")

    local author, author_mail, author_time, author_tz
    local committer, committer_mail, committer_time, committer_tz
    local summary, previous, filename

    for _, blame_line in ipairs(lines) do
      if blame_line:match("^author ") then
        author = blame_line:match("^author (.+)")
      elseif blame_line:match("^author%-mail") then
        author_mail = blame_line:match("^author%-mail <(.+)>")
      elseif blame_line:match("^author%-time") then
        author_time = blame_line:match("^author%-time (%d+)")
      elseif blame_line:match("^author%-tz") then
        author_tz = blame_line:match("^author%-tz (.+)")
      elseif blame_line:match("^committer ") then
        committer = blame_line:match("^committer (.+)")
      elseif blame_line:match("^committer%-time") then
        committer_time = blame_line:match("^committer%-time (%d+)")
      elseif blame_line:match("^summary") then
        summary = blame_line:match("^summary (.+)")
      elseif blame_line:match("^previous") then
        previous = blame_line:match("^previous (%w+)")
      elseif blame_line:match("^filename") then
        filename = blame_line:match("^filename (.+)")
      end
    end

    -- Get commit details
    local show_cmd = string.format('git show --no-patch --format="%%B" %s', commit_hash)
    local commit_message = vim.fn.system(show_cmd)

    -- Get file changes in this commit
    local stat_cmd = string.format("git show --stat --oneline %s", commit_hash)
    local commit_stats = vim.fn.system(stat_cmd)

    -- Format date
    local formatted_date = "Unknown"
    if author_time then
      formatted_date = vim.fn.strftime("%Y-%m-%d %H:%M:%S", tonumber(author_time))
    end

    -- Build display content
    local content = {
      "",
      "📝 Commit: " .. (commit_hash or "Unknown"),
      "👤 Author: " .. (author or "Unknown") .. " <" .. (author_mail or "") .. ">",
      "📅 Date: " .. formatted_date .. " " .. (author_tz or ""),
      "📄 File: " .. (filename or relative_file),
      "",
      "💬 Message:",
      "──────────────────────────────────────────",
    }

    -- Add commit message lines
    if commit_message and commit_message ~= "" then
      local msg_lines = vim.split(vim.trim(commit_message), "\n")
      for _, msg_line in ipairs(msg_lines) do
        table.insert(content, "  " .. msg_line)
      end
    else
      table.insert(content, "  " .. (summary or "No message"))
    end

    table.insert(content, "")
    table.insert(content, "📊 Changes in this commit:")
    table.insert(
      content,
      "──────────────────────────────────────────"
    )

    -- Add commit stats
    if commit_stats and commit_stats ~= "" then
      local stat_lines = vim.split(vim.trim(commit_stats), "\n")
      --   for i, stat_line in ipairs(stat_lines) do
      --     if i > 1 then -- Skip the first line (commit hash + summary)
      table.insert(content, "  " .. stat_lines[#stat_lines])
      --     end
      --   end
    end

    -- Create popup
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

    -- Set syntax highlighting
    vim.api.nvim_buf_set_option(buf, "filetype", "gitblame")

    -- Calculate dimensions
    local width = math.min(vim.o.columns - 8, 100)
    local height = math.min(#content + 2, vim.o.lines - 10)

    local opts = {
      relative = "editor",
      width = width,
      height = height,
      col = math.floor((vim.o.columns - width) / 2),
      row = math.floor((vim.o.lines - height) / 2),
      style = "minimal",
      border = "rounded",
      title = " Git Blame Line " .. line .. " ",
      title_pos = "center",
    }

    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "readonly", true)

    -- Close on escape or q
    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<cr>", { silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<cr>", { silent = true })

    -- Add some basic syntax highlighting
    vim.api.nvim_buf_add_highlight(buf, -1, "Title", 0, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, -1, "Comment", 1, 0, -1)

    for i, content_line in ipairs(content) do
      if
        content_line:match("^📝")
        or content_line:match("^👤")
        or content_line:match("^📅")
        or content_line:match("^📄")
      then
        vim.api.nvim_buf_add_highlight(buf, -1, "Identifier", i - 1, 0, -1)
      elseif content_line:match("^💬") or content_line:match("^📊") or content_line:match("^⬅️") then
        vim.api.nvim_buf_add_highlight(buf, -1, "Special", i - 1, 0, -1)
      elseif content_line:match("^──") or content_line:match("^══") then
        vim.api.nvim_buf_add_highlight(buf, -1, "Comment", i - 1, 0, -1)
      end
    end
  end,

  show_file_info_popup = function()
    local file = vim.fn.expand("%:p")
    local name = vim.fn.expand("%:t")
    local dir = vim.fn.expand("%:h")
    local size = vim.fn.getfsize(file)
    local modified = vim.fn.getftime(file)
    local modified_str = os.date("%Y-%m-%d %H:%M:%S", modified)

    local info = "File: "
      .. name
      .. "\n"
      .. dir
      .. "\n"
      .. "Size: "
      .. (size > 0 and bytes_to_human(size))
      .. "\n"
      .. "Modified: "
      .. modified_str

    Snacks.notify.info(info)
  end,

  get_path_from_file = function(_, file)
    local parts = {}
    for part in file:gmatch("[^/]+") do
      table.insert(parts, part)
    end
    table.remove(parts)
    return table.concat(parts, "/")
  end,

  get_neotree_selection = function(self)
    local sm = require("neo-tree.sources.manager")
    local state = sm:_get_all_states()[1]
    local node = state.tree:get_node()
    local treeselection = node.path
    if node.type ~= "directory" then
      treeselection = self:get_path_from_file(treeselection)
    end
    return treeselection
  end,

  pick_files = function(self)
    local treeselection = vim.fn.getcwd()
    if vim.bo.filetype == "neo-tree" then
      treeselection = self:get_neotree_selection()
    end

    Snacks.picker.smart({
      title = "SMART:" .. treeselection,
      dirs = { treeselection },
      hidden = true,
      multi = { "buffers", "files" },
      matcher = { sort_empty = false },
    })
  end,

  live_grep = function(self)
    local treeselection = ""
    if vim.bo.filetype == "neo-tree" then
      treeselection = self:get_neotree_selection()
    end

    if treeselection == "" then
      Snacks.picker.grep_buffers({ title = "GREP: Open files", hidden = true })
    else
      Snacks.picker.grep({
        dirs = { treeselection },
        title = "GREP: " .. treeselection,
        hidden = true,
        -- hook = function(args, _)
        --   local new_args = {}
        --   local dir_args = ""
        --   for _, arg in ipairs(args) do
        --     local part1, part2 = arg:match("(.+) // (.+)")
        --     if part1 and part2 then
        --       table.insert(new_args, part1)
        --       if not string.find(part2, "%*") then
        --         part2 = part2 .. "/*"
        --       end
        --       dir_args = "**/" .. part2
        --     else
        --       table.insert(new_args, arg)
        --     end
        --     -- end
        --   end
        --   local i = findIndex(new_args, "--")
        --   if i and dir_args ~= "" then
        --     table.insert(new_args, i, dir_args)
        --     table.insert(new_args, i, "-g")
        --   end
        --
        --   return new_args
        -- end,
      })
    end
  end,

  -- open definition in a floating window next to the cursor, but stay in the window if the def
  definition_in_float = function()
    local params = vim.lsp.util.make_position_params(0, "utf-8")
    vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, _, _)
      if not result or vim.tbl_isempty(result) then
        return
      end

      local location = result[1]

      local target_uri = location.uri or location.targetUri
      local target_bufnr = vim.uri_to_bufnr(target_uri)

      -- Check if we're in a floating window
      local current_win = vim.api.nvim_get_current_win()
      local current_bufnr = vim.api.nvim_win_get_buf(current_win)
      local win_config = vim.api.nvim_win_get_config(current_win)

      -- If we're in a floating window and the definition is in the same buffer
      if win_config.relative ~= "" and current_bufnr == target_bufnr then
        -- Just jump to the location in the current floating window
        vim.api.nvim_win_set_cursor(current_win, { location.range.start.line + 1, location.range.start.character })
        return
      end

      -- Otherwise, create a new floating window
      vim.fn.bufload(target_bufnr)

      -- Get filename for title
      local filename = vim.uri_to_fname(target_uri)

      local win_id = vim.api.nvim_open_win(target_bufnr, true, {
        relative = "cursor",
        width = 80,
        height = 20,
        row = 1,
        col = 0,
        style = "minimal",
        border = "rounded",
        title = filename,
        title_pos = "center",
      })

      local startLine = -1
      local startChar = -1

      if location.range and location.range.start then
        startLine = location.range.start.line
        startChar = location.range.start.character
      end

      if location.targetRange and location.targetRange.start then
        startLine = location.targetRange.start.line
        startChar = location.targetRange.start.character
      end

      vim.api.nvim_win_set_cursor(win_id, { startLine + 1, startChar })

      -- Close on <Esc>
      vim.keymap.set("n", "<Esc>", function()
        if vim.api.nvim_win_is_valid(win_id) then
          vim.api.nvim_win_close(win_id, true)
        end
      end, { buffer = target_bufnr, nowait = true })
    end)
  end,

  delete_automarks = function(global)
    vim.cmd(global and "delmarks A-Z" or "delmarks a-z")
  end,

  automark = function(global)
    global = global or false
    local ms = global and "ABCDEFGHIJKLMNOPQRSTUVWXYZ" or "abcdefghijklmnopqrstuvwxyz"

    local line = vim.api.nvim_win_get_cursor(0)[1]
    local pos = vim.api.nvim_win_get_cursor(0)[2]

    local marks = get_filtered_marks(global)

    for _, mark in ipairs(marks) do
      if mark.pos[2] == line then
        local m = mark.mark:sub(-1)
        vim.api.nvim_buf_del_mark(0, m)
        table.insert(global and deleted_marks_global or deleted_marks, m)
        return
      end
    end

    local dm = global and deleted_marks_global or deleted_marks

    if #dm > 0 then
      local mark = table.remove(global and deleted_marks_global or deleted_marks, 1)
      vim.api.nvim_buf_set_mark(0, mark, line, pos, {})
      return
    end

    local ct = 0
    for _, mark in ipairs(marks) do
      local m = mark.mark:sub(-1)
      local pos = string.find(ms, m)
      if pos and pos > ct then
        ct = pos
      end
    end

    local mark = ms:sub(ct + 1, ct + 1)
    vim.api.nvim_buf_set_mark(0, mark, line, pos, {})
  end,

  cycle_through_marks = function(global)
    local marks = get_filtered_marks(global or false)

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
      vim.api.nvim_feedkeys("`" .. next_mark.mark:sub(-1), "n", true)
    end
  end,

  open_dialog = function(type, title)
    local target_dir = vim.fn.input(title .. ": ", vim.fn.getcwd() .. "/", type)
    if target_dir ~= "" then
      vim.cmd("e " .. vim.fn.fnameescape(target_dir))
      vim.cmd("cd " .. vim.fn.fnameescape(target_dir))
      vim.cmd("SessionRestore")
    end -- funcs.open_folder_dialog(nil, "/home")
  end,

  smart_close = function(self)
    local bts = { "nofile", "quickfix", "help", "terminal", "prompt" }
    local fts = { "DiffviewFileHistory" }
    local bt = vim.bo.buftype
    local ft = vim.bo.filetype
    if arrayHas(fts, ft) then
      vim.cmd(":q")
      if ft == "DiffviewFileHistory" then
        vim.cmd(":tabclose")
      end
      return
    end

    if arrayHas(bts, bt) then
      vim.cmd(":q")
      return
    end
  end,

  get_tree_main_win = function(_)
    local neotree_win = nil
    local main_win = nil

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local b = vim.api.nvim_win_get_buf(win)
      local buf = vim.bo[b]
      local filetype = buf.filetype
      if filetype == "neo-tree" then
        neotree_win = win
      else
        if buf.buftype == "" then
          main_win = win
        end
      end
    end
    return { neotree_win = neotree_win, main_win = main_win }
  end,

  toggle_search_replace = function(self, instance)
    local gf = require("grug-far")
    local paths = vim.fn.expand("%")
    local treeselection = ""
    local wins = self:get_tree_main_win()
    local neotree_win = wins.neotree_win
    local main_win = wins.main_win

    if main_win and vim.api.nvim_get_current_win() == neotree_win then
      treeselection = self:get_neotree_selection()
      vim.api.nvim_set_current_win(main_win)
    end
    if instance == "project" then
      paths = treeselection
    end
    local prefills = { paths = paths, flags = "--multiline" }
    if not gf.has_instance(instance) then
      gf.open({
        instanceName = instance,
        windowCreationCommand = "split",
        prefills = prefills,
      })
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
      local items = {}
      if #results > 0 then
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
      end

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

  toggle_tree = function(self)
    local wins = self:get_tree_main_win()
    local neotree_win = wins.neotree_win
    local main_win = wins.main_win

    if main_win and vim.api.nvim_get_current_win() == neotree_win then
      vim.api.nvim_set_current_win(main_win)
    else
      vim.api.nvim_set_current_win(neotree_win)
      vim.cmd("vertical resize 40%")
    end

    -- if vim.bo.filetype == "neo-tree" then
    --   vim.cmd("wincmd p")
    -- else
    --   local neotree = require("neo-tree.command")
    --   neotree.execute({ action = "focus" })
    --   vim.cmd("vertical resize 40%")
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
    local language_servers = string.format("%s", client_names_str)

    return language_servers
  end,
}

return M
