-- Require-on-demand helper library. Pull in with require("tluan.core.utils").
-- Not loaded at startup, so keep it side-effect free.

local M = {}

--- Get highlight properties for a given highlight name
--- @param name string The highlight group name
--- @param fallback? table The fallback highlight properties
--- @return table properties # the highlight group properties
function M.get_hlgroup(name, fallback)
  if vim.fn.hlexists(name) == 1 then
    local group = vim.api.nvim_get_hl(0, { name = name })

    local hl = {
      fg = group.fg == nil and "NONE" or M.parse_hex(group.fg),
      bg = group.bg == nil and "NONE" or M.parse_hex(group.bg),
    }

    return hl
  end
  return fallback or {}
end

--- Remove a buffer by its number without affecting window layout
--- @param buf? number The buffer number to delete
function M.delete_buffer(buf)
  if buf == nil or buf == 0 then
    buf = vim.api.nvim_get_current_buf()
  end
  local win_id = vim.fn.bufwinid(buf)
  local alt_buf = vim.fn.bufnr("#")
  if alt_buf ~= buf and vim.fn.buflisted(buf) == 1 and alt_buf ~= -1 then
    vim.api.nvim_win_set_buf(win_id, alt_buf)
    vim.api.nvim_command("bwipeout " .. buf)
    return
  end

  ---@diagnostic disable-next-line: param-type-mismatch
  local has_prev_buf = pcall(vim.cmd, "bprevious")
  if has_prev_buf and buf ~= vim.api.nvim_win_get_buf(win_id) then
    vim.api.nvim_command("bwipeout " .. buf)
    return
  end

  -- if alternate and previous buffers are both unavailable, create a new buffer instead
  local new_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win_id, new_buf)
  vim.api.nvim_command("bwipeout " .. buf)
end

--- Switch to the previous buffer
function M.switch_to_other_buffer()
  -- try alternate buffer first
  local ok, _ = pcall(function()
    vim.cmd("buffer #")
  end)
  if ok then
    return
  end

  -- fallback to previous buffer
  if M.get_buffer_count() > 1 then
    vim.cmd("bprevious")
    return
  end

  vim.notify("No other buffer to switch to!", 3, { title = "Warning" })
end

--- Get the number of open buffers
--- @return number
function M.get_buffer_count()
  local count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.bufname(buf) ~= "" then
      count = count + 1
    end
  end
  return count
end

--- Parse a given integer color to a hex value.
--- @param int_color number
function M.parse_hex(int_color)
  return string.format("#%x", int_color)
end

--- Create a centered floating window of a given width and height, relative to the size of the screen.
--- @param width number width of the window where 1 is 100% of the screen
--- @param height number height of the window - between 0 and 1
--- @param buf number The buffer number
--- @return number The window number
function M.open_centered_float(width, height, buf)
  buf = buf or vim.api.nvim_create_buf(false, true)
  local win_width = math.floor(vim.o.columns * width)
  local win_height = math.floor(vim.o.lines * height)
  local offset_y = math.floor((vim.o.lines - win_height) / 2)
  local offset_x = math.floor((vim.o.columns - win_width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = offset_y,
    col = offset_x,
    style = "minimal",
    border = "single",
  })

  return win
end

--- Open the help window in a floating window
--- @param buf number The buffer number
function M.open_help(buf)
  if buf ~= nil and vim.bo[buf].filetype == "help" and not vim.bo[buf].modifiable then
    local help_win = vim.api.nvim_get_current_win()
    local new_win = M.open_centered_float(0.6, 0.7, buf)

    -- set scroll position
    vim.wo[help_win].scroll = vim.wo[new_win].scroll

    -- close the help window
    vim.api.nvim_win_close(help_win, true)
  end
end

return M
