local u = require("util")
local m = u.lazy_map

local function expand_class(tsnode)
  local sibling = tsnode:prev_named_sibling()
  if not sibling then
    return
  end
  local row = tsnode:start()
  local _, attr_col = sibling:start()
  local node_text = vim.treesitter.get_node_text(tsnode, 0)
  local quote = node_text:sub(1, 1)
  local classes = u.split_string(node_text)
  classes[1] = classes[1]:sub(2)
  classes[#classes] = classes[#classes]:sub(1, -2)
  local spaces = (" "):rep(attr_col)
  local lines = { spaces .. "class=" .. quote }
  for _, class in ipairs(classes) do
    table.insert(lines, spaces .. (" "):rep(vim.bo.shiftwidth) .. class)
  end
  table.insert(lines, spaces .. quote)
  vim.api.nvim_buf_set_lines(0, row, row + 1, false, lines)
  if not vim.b.disable_autoformat then
    vim.b.disable_autoformat = true
  end
end

local function collapse_class(tsnode)
  local row_start, col_start = tsnode:start()
  local row_end, col_end = tsnode:end_()
  local node_text = vim.treesitter.get_node_text(tsnode, vim.api.nvim_get_current_buf())
  local quote = node_text:sub(1, 1)
  local cleaned_text = node_text:gsub("\n", " "):gsub("%s+", " "):match("^%s*(.-)%s*$"):sub(3, -3)
  local line = "=" .. quote .. cleaned_text .. quote
  vim.api.nvim_buf_set_text(0, row_start, col_start - 1, row_end, col_end, { line })
  if vim.b.disable_autoformat then
    vim.b.disable_autoformat = false
  end
end

local function handle_node(tsnode)
  local row = tsnode:start()
  local end_row = tsnode:end_()
  if row == end_row then
    expand_class(tsnode)
  else
    collapse_class(tsnode)
  end
end

local function class_action(tsnode)
  local node_text = vim.treesitter.get_node_text(tsnode, 0)
  if node_text == "class" then
    tsnode = tsnode:next_named_sibling()
    if not tsnode then
      return
    end
    handle_node(tsnode)
  end
end

local function get_node_text(tsnode)
  return vim.treesitter.get_node_text(tsnode, 0)
end

return {
  "CKolkey/ts-node-action",
  opts = {
    vue = {
      ["attribute_name"] = function(tsnode)
        -- class_action(tsnode)
        local node_text = get_node_text(tsnode)
        if node_text == "class" then
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
            local classes =
              classes_text:gsub("\n", " "):gsub(quote .. "%s+", quote):gsub("%s+" .. quote, quote)
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
            classes[#classes + 1] = quote
            return classes, opts
          end
        end
      end,
      ["attribute_value"] = function(tsnode)
        tsnode = tsnode:parent()
        if not tsnode then
          return
        end
        tsnode = tsnode:prev_named_sibling()
        class_action(tsnode)
      end,
      ["quoted_attribute_value"] = function(tsnode)
        tsnode = tsnode:prev_named_sibling()
        class_action(tsnode)
      end,
    },
  },
  keys = {
    m("<leader>i", [[lua require("ts-node-action").node_action()]]),
  },
}
