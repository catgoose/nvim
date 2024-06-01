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
    attrs[#attrs + 1] = spaces .. quote
    return attrs, opts
  end
end

local function handle_tag_name(tsnode, cursor)
  cursor = cursor or {}
  local tag_text = u.get_node_text(tsnode)

  local parent = tsnode:parent()
  if not parent then
    return
  end
  local parent_text = u.get_node_text(parent)

  local tag_start = parent_text:sub(1, 1)
  local tag_end = parent_text:sub(-2)
  if tag_end ~= "/>" then
    tag_end = parent_text:sub(-1)
  end

  local element = { tag_start .. tag_text }
  local sibling = tsnode:next_named_sibling()
  while sibling do
    table.insert(element, u.get_node_text(sibling))
    sibling = sibling:next_named_sibling()
  end
  element[#element + 1] = tag_end

  local multiline = string.find(parent_text, "\n")
  local opts = {
    target = tsnode:parent(),
    callback = function()
      vim.b.disable_autoformat = true
    end,
    format = true,
    cursor = cursor,
  }
  if multiline then
    if tag_end == ">" then
      element[#element - 1] = element[#element - 1] .. tag_end
      element[#element] = nil
    end
    return table.concat(element, " "), opts
  else
    return element, opts
  end
end

local function get_first_sibling(tsnode)
  local sibling = tsnode:prev_named_sibling()
  if not sibling then
    return tsnode
  end
  while sibling do
    local new_sibling = sibling:prev_named_sibling()
    if not new_sibling then
      return sibling
    else
      sibling = new_sibling
    end
  end
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
    if #u.split_string(attribute_value) > 1 then
      return handle_attribute_value(sibling)
    else
      local parent = tsnode:parent()
      if not parent then
        return
      end
      local tagnode = get_first_sibling(parent)
      return handle_tag_name(tagnode)
    end
  end,
  tag_name = function(tsnode)
    return handle_tag_name(tsnode)
  end,
  handle_attribute = function(tsnode)
    local tagnode = get_first_sibling(tsnode)
    return handle_tag_name(tagnode)
  end,
}

return M
