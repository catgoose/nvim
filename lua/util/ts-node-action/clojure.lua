local u = require("util")

local M = {}

local wrappable_nodes = {
  ["list_lit"] = true,
  ["vec_lit"] = true,
  ["map_lit"] = true,
  ["ns_map_lit"] = true,
  ["set_lit"] = true,
  ["fn_lit"] = true,
  ["anon_fn_lit"] = true,
  ["quote_lit"] = true,
  ["meta_lit"] = true,
  ["deref_lit"] = true,
  ["var_quoting_lit"] = true,
}

local function is_wrappable_node(tsnode)
  if not tsnode then
    return false
  end

  local node_type = tsnode:type()
  if wrappable_nodes[node_type] then
    return true
  end

  if node_type:match("_lit$") then
    return true
  end

  return node_type:find("sym") ~= nil or node_type == "symbol" or node_type == "multi_symbol"
end

local function get_wrappable_node()
  local tsnode = vim.treesitter.get_node({
    bufnr = 0,
    ignore_injections = false,
  })

  if not tsnode then
    return
  end

  local current = tsnode
  while current do
    if is_wrappable_node(current) then
      return current
    end
    current = current:parent()
  end
end

local function indent_width()
  local width = vim.bo.shiftwidth
  if width == 0 then
    width = vim.bo.tabstop
  end
  if width == 0 then
    width = 2
  end
  return width
end

local function cursor_on_list_end(cursor, end_row, end_col)
  return cursor[1] == end_row + 1 and cursor[2] >= (end_col - 1)
end

local function split_list_before_close(node_text, start_col)
  local lines = vim.split(node_text, "\n", { plain = true })
  local outer_prefix = (" "):rep(start_col)
  local inner_prefix = (" "):rep(start_col + indent_width())
  local last_line = lines[#lines] or ""

  if vim.trim(last_line) == ")" then
    table.remove(lines, #lines)
  else
    lines[#lines] = last_line:sub(1, -2)
  end

  lines[#lines + 1] = inner_prefix
  lines[#lines + 1] = outer_prefix .. ")"
  return lines
end

function M.wrap_form()
  local tsnode = get_wrappable_node()
  if not tsnode then
    vim.notify("No Clojure form found under cursor", vim.log.levels.WARN)
    return
  end

  local bufnr = 0
  local start_row, start_col, end_row, end_col = tsnode:range()
  local node_text = u.get_node_text(tsnode, bufnr)
  if type(node_text) == "table" then
    node_text = table.concat(node_text, "\n")
  end
  if not node_text or node_text == "" then
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local replacement
  local next_cursor = { cursor[1], cursor[2] }
  local enter_insert = false

  if tsnode:type() == "list_lit" then
    if cursor_on_list_end(cursor, end_row, end_col) then
      replacement = split_list_before_close(node_text, start_col)
      next_cursor = { start_row + #replacement - 1, start_col + indent_width() }
      enter_insert = true
    else
      replacement = "( " .. node_text .. ")"
      next_cursor = { start_row + 1, start_col + 1 }
      enter_insert = true
    end
  else
    replacement = "(" .. node_text .. ")"
    if cursor[1] == start_row + 1 then
      next_cursor = { cursor[1], cursor[2] + 1 }
    end
  end

  vim.api.nvim_buf_set_text(
    bufnr,
    start_row,
    start_col,
    end_row,
    end_col,
    type(replacement) == "table" and replacement or vim.split(replacement, "\n", { plain = true })
  )
  vim.api.nvim_win_set_cursor(0, next_cursor)

  if enter_insert then
    vim.cmd.startinsert()
  end
end

return M
