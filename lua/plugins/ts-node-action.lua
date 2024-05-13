local u = require("util")
local m = u.lazy_map

local function get_node_text(tsnode)
  return vim.treesitter.get_node_text(tsnode, 0)
end

local function class_action(tsnode)
  local node_text = get_node_text(tsnode)
  if node_text ~= "class" then
    return
  end
  local sibling = tsnode:next_named_sibling()
  if not sibling then
    return
  end
  local classes_text = get_node_text(sibling)
  if not classes_text then
    return
  end

  local quote = classes_text:sub(1, 1)
  local multiline = string.find(classes_text, "\n")
  local opts = {
    target = sibling,
    callback = function()
      vim.b.disable_autoformat = not vim.b.disable_autoformat and not multiline
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
end

return {
  "CKolkey/ts-node-action",
  opts = {
    vue = {
      ["attribute_name"] = function(tsnode)
        return class_action(tsnode)
      end,
      ["attribute_value"] = function(tsnode)
        local parent = tsnode:parent()
        if not parent then
          return
        end
        local sibling = parent:prev_named_sibling()
        if not sibling then
          return
        end
        return class_action(sibling)
      end,
      ["quoted_attribute_value"] = function(tsnode)
        local sibling = tsnode:prev_named_sibling()
        if not sibling then
          return
        end
        return class_action(sibling)
      end,
    },
  },
  keys = {
    m("<leader>i", [[lua require("ts-node-action").node_action()]]),
  },
}
