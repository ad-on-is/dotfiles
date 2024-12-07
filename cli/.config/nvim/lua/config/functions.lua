return {
  live_grep_current_tree_selection = function()
    local api = require("nvim-tree.api")
    local node = api.tree.get_node_under_cursor()

    if not node then
      -- If no node is selected, search from cwd
      require("telescope.builtin").live_grep()
      return
    end

    local path
    if node.type == "directory" then
      path = node.absolute_path
    else
      -- If file is selected, search from its parent directory
      path = vim.fn.fnamemodify(node.absolute_path, ":h")
    end

    -- Ensure the path exists and is accessible
    if vim.fn.isdirectory(path) == 0 then
      vim.notify("Invalid directory path: " .. path, vim.log.levels.ERROR)
      return
    end

    -- Configure and launch telescope live_grep
    require("telescope.builtin").live_grep({
      cwd = path,
      prompt_title = "Live Grep: " .. vim.fn.fnamemodify(path, ":~"),
      search_dirs = { path },
    })
  end,

  toggle_nvimtree = function()
    local view = require("nvim-tree.view")
    if view.is_visible() then
      if vim.api.nvim_get_current_win() == view.get_winnr() then
        -- Currently focused on nvim-tree, switch to other window
        vim.cmd("wincmd p")
      else
        -- Currently focused on other window, switch to nvim-tree
        view.focus()
      end
    else
      -- NvimTree not visible, open it
      require("nvim-tree.api").tree.open()
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
    if
      vim.api.nvim_buf_get_name(0) == ""
      or (vim.api.nvim_buf_line_count(0) == 1 and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == "")
    then
      -- Use input() to prompt for filename
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
}
