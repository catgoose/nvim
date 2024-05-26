local u = require("util")
local M = {}

local function handle_attribute_value(tsnode)
  local node_text = u.get_node_text(tsnode)
  if not node_text then
    return
  end
  local quote = node_text:sub(1, 1)
  local multiline = string.find(node_text, "\n")
  local opts = {
    target = tsnode,
    callback = function()
      vim.b.disable_autoformat = true
    end,
    format = true,
  }
  if multiline then
    local line = node_text
      :gsub("\n", " ")
      :gsub(quote .. "%s+", quote)
      :gsub("%s+" .. quote, quote)
      :gsub("%s+", " ")
    opts.cursor = {}
    return line, opts
  else
    local _attrs = u.split_string(node_text)
    _attrs[1] = _attrs[1]:sub(2)
    _attrs[#_attrs] = _attrs[#_attrs]:sub(1, -2)
    local attrs = { quote }
    local _, attr_col = tsnode:start()
    local spaces = (" "):rep(attr_col)
    for _, attr in ipairs(_attrs) do
      table.insert(attrs, spaces .. (" "):rep(vim.bo.shiftwidth) .. attr)
    end
    opts.cursor = { row = 1 }
    attrs[#attrs + 1] = spaces .. quote
    return attrs, opts
  end
end

local function handle_tag_name(tsnode)
  local tag_text = u.get_node_text(tsnode)
  local parent = tsnode:parent()
  if not parent then
    return
  end
  local parent_text = u.get_node_text(parent)
  local tag_start = parent_text:sub(1, 1)
  local tag_end = parent_text:sub(-1)

  local tag_tbl = { tag_start .. tag_text }

  local sibling = tsnode:next_named_sibling()
  while sibling do
    table.insert(tag_tbl, (" "):rep(vim.bo.shiftwidth * 2) .. u.get_node_text(sibling))
    sibling = sibling:next_named_sibling()
  end
  table.insert(tag_tbl, (" "):rep(vim.bo.shiftwidth) .. tag_end)

  local opts = {
    cursor = { row = 1, col = vim.bo.shiftwidth },
    target = tsnode:parent(),
    callback = function()
      vim.b.disable_autoformat = true
    end,
    format = true,
  }
  return tag_tbl, opts
end

M.vue = {
  attribute_name = function(tsnode)
    local sibling = tsnode:next_named_sibling()
    if not sibling then
      return
    end
    local attribute_value = u.get_node_text(sibling)
    if not attribute_value then
      return
    end
    --  TODO: 2024-05-25 - What does this mean and what should be returned
    -- if multiple lines aren't received?
    if #u.split_string(attribute_value) > 1 then
      return handle_attribute_value(sibling)
    end
  end,
  tag_name = function(tsnode)
    return handle_tag_name(tsnode)
  end,
}

return M
