local u = require("util")
local M = {}

M.vue = {
  tag_name = function(tsnode)
    local tag_text = u.get_node_text(tsnode)
    local parent = tsnode:parent()
    if not parent then
      return
    end
    local parent_text = u.get_node_text(parent)
    local tag_start = parent_text:sub(1, 1)
    local tag_end = parent_text:sub(-1)
    local tag_tbl = { tag_start .. tag_text }
    local sibiling = tsnode:next_named_sibling()
    if not sibiling then
      return
    end
    table.insert(tag_tbl, (" "):rep(vim.bo.shiftwidth) .. u.get_node_text(sibiling))
    table.insert(tag_tbl, (" "):rep(vim.bo.shiftwidth) .. tag_end)
    local opts = {
      cursor = { row = 1, col = vim.bo.shiftwidth },
      target = tsnode:parent(),
      callback = function()
        --  TODO: 2024-05-16 - Check if there are any expanded classes and set
        --  disable format accordingly
        vim.b.disable_autoformat = true
      end,
    }
    return tag_tbl, opts
  end,
  class_action = function(tsnode)
    local node_text = u.get_node_text(tsnode)
    if node_text ~= "class" then
      return
    end
    local sibling = tsnode:next_named_sibling()
    if not sibling then
      return
    end
    local classes_text = u.get_node_text(sibling)
    if not classes_text then
      return
    end

    local quote = classes_text:sub(1, 1)
    local multiline = string.find(classes_text, "\n")
    local opts = {
      cursor = {},
      target = sibling,
      callback = function()
        --  TODO: 2024-05-16 - Check if there are any expanded classes and set
        --  disable format accordingly
        vim.b.disable_autoformat = true
      end,
    }

    if multiline then
      local classes = classes_text
        :gsub("\n", " ")
        :gsub(quote .. "%s+", quote)
        :gsub("%s+" .. quote, quote)
        :gsub("%s+", " ")
      return classes, opts
    else
      local _classes = u.split_string(classes_text)
      _classes[1] = _classes[1]:sub(2)
      _classes[#_classes] = _classes[#_classes]:sub(1, -2)
      local classes = { quote }
      local _, attr_col = tsnode:start()
      local spaces = (" "):rep(attr_col)
      for _, class in ipairs(_classes) do
        table.insert(classes, spaces .. (" "):rep(vim.bo.shiftwidth) .. class)
      end
      classes[#classes + 1] = spaces .. quote
      return classes, opts
    end
  end,
}

return M
