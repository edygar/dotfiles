-- lua/quickfix_from_paste.lua
local M = {}

function M.quickfix_from_paste_prompt()
  -- Create a new buffer as 'scratch' (which implies nobuflisted, noswapfile, noundofile)
  local buf = vim.api.nvim_create_buf(false, true) -- listed=false, scratch=true

  vim.api.nvim_set_option_value("filetype", "quickfix_input", { buf = buf })

  -- Open the buffer in a new window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor", -- Relative to the whole editor area
    width = math.floor(vim.o.columns * 0.8), -- 80% width
    height = math.floor(vim.o.lines * 0.3), -- 30% height
    row = math.floor(vim.o.lines * 0.1),
    col = math.floor(vim.o.columns * 0.1),
    border = "single", -- Add a border
    focusable = true,
    title = "Paste File Paths",
    title_pos = "center",
  })

  -- Set buffer contents with instructions
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "Paste your file list here (e.g., path/to/file.js:123).",
    "Press <S-CR> (Shift+Enter) when done.",
    "", -- Add an empty line for easier pasting directly below instructions
  })

  -- Move cursor to the third line, ready for pasting
  vim.api.nvim_win_set_cursor(win, { 3, 0 })

  -- Define the function to process the buffer content
  local function process_quickfix_input()
    -- Get buffer lines (excluding the first two instruction lines)
    local raw_lines = vim.api.nvim_buf_get_lines(buf, 2, -1, false)

    local qf_list_entries = {}
    for _, line in ipairs(raw_lines) do
      local trimmed_line = line:match "^%s*(.*%S)%s*$" or "" -- Trim leading/trailing whitespace

      if #trimmed_line > 0 then
        local entry = { text = "File from input" } -- Default text for the quickfix entry

        -- Try to parse as filepath:linenumber
        local file_path, line_num_str = trimmed_line:match "^(.*):(%d+)$"

        if file_path and line_num_str then
          entry.filename = file_path
          entry.lnum = tonumber(line_num_str)
          entry.col = 1 -- Default to first column if no column specified
        else
          -- Assume it's just a filepath, default to line 1
          entry.filename = trimmed_line
          entry.lnum = 1
          entry.col = 1
        end

        table.insert(qf_list_entries, entry)
      end
    end

    -- Handle the case where no valid lines are provided
    if #qf_list_entries == 0 then
      vim.notify("No file paths provided or parsed successfully.", vim.log.WARN)
      vim.api.nvim_win_close(win, true)
      vim.api.nvim_buf_delete(buf, { force = true })
      return
    end

    -- Set the quickfix list using vim.fn.setqflist
    -- The second argument (mode) 'r' replaces the list, 'a' appends.
    -- We want to replace it for a fresh list from the input.
    vim.fn.setqflist({}, "r", { items = qf_list_entries })

    -- Close the input window/buffer
    vim.api.nvim_win_close(win, true) -- force close
    vim.api.nvim_buf_delete(buf, { force = true })

    -- Open quickfix window
    vim.cmd "copen"

    vim.notify("Quickfix list updated!", vim.log.INFO)
  end

  -- Expose the processing function to be callable from the keymap callback
  M.process_temp_buffer = process_quickfix_input

  -- Map <S-CR> in insert and normal mode within this buffer/window
  vim.api.nvim_buf_set_keymap(
    buf,
    "i",
    "<S-CR>",
    "", -- Empty RHS, logic in callback
    {
      noremap = true,
      silent = true,
      callback = function() M.process_temp_buffer() end,
    }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "<S-CR>",
    "", -- Empty RHS, logic in callback
    {
      noremap = true,
      silent = true,
      callback = function() M.process_temp_buffer() end,
    }
  )

  -- Place the cursor and enter insert mode
  vim.api.nvim_set_current_win(win)
  vim.cmd "startinsert"
end

return M
