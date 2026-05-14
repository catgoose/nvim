local u = require("util")
local ts_helpers = require("ts-node-action.helpers")
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

M.html = {
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

local clojure_binding_forms = {
  ["binding"] = true,
  ["doseq"] = true,
  ["for"] = true,
  ["if-let"] = true,
  ["if-some"] = true,
  ["let"] = true,
  ["let*"] = true,
  ["loop"] = true,
  ["when-let"] = true,
  ["when-some"] = true,
  ["with-local-vars"] = true,
  ["with-open"] = true,
}

local function normalize_text(text)
  if not text then
    return
  end
  return vim.trim(text:gsub("%s+", " "))
end

local function normalize_node_text(tsnode)
  return normalize_text(u.get_node_text(tsnode))
end

local function named_children(tsnode)
  local children = {}
  for child in tsnode:iter_children() do
    if child:named() then
      children[#children + 1] = child
    end
  end
  return children
end

local function collection_edges(tsnode)
  local opening = {}
  local closing = {}
  local seen_named = false

  for child in tsnode:iter_children() do
    if child:named() then
      seen_named = true
    else
      local text = normalize_text(u.get_node_text(child))
      if text and text ~= "" then
        if seen_named then
          closing[#closing + 1] = text
        else
          opening[#opening + 1] = text
        end
      end
    end
  end

  return table.concat(opening, ""), table.concat(closing, "")
end

local function node_text_lines(tsnode)
  local text = ts_helpers.node_text(tsnode)
  if not text then
    return
  end

  if type(text) == "string" then
    local normalized = normalize_text(text)
    if not normalized or normalized == "" then
      return
    end
    return { normalized }
  end

  local lines = {}
  for _, line in ipairs(text) do
    local normalized = normalize_text(line)
    if not normalized or normalized == "" then
      return
    end
    lines[#lines + 1] = normalized
  end
  return lines
end

local function stringify_lines(lines)
  return table.concat(lines, " ")
end

local function build_generic_items(children, preserve_multiline)
  local items = {}
  for _, child in ipairs(children) do
    if child:extra() or child:type():match("comment") then
      return
    end

    local lines = node_text_lines(child)
    if not lines or vim.tbl_isempty(lines) then
      return
    end
    if preserve_multiline and #lines > 1 then
      items[#items + 1] = lines
    else
      items[#items + 1] = stringify_lines(lines)
    end
  end
  return items
end

local function compose_pair_item(left_lines, right_lines, preserve_multiline)
  if not left_lines or not right_lines or #left_lines ~= 1 then
    return
  end

  if preserve_multiline and #right_lines > 1 then
    local item = { left_lines[1] .. " " .. right_lines[1] }
    local pad = (" "):rep(#left_lines[1] + 1)
    for i = 2, #right_lines do
      item[#item + 1] = pad .. right_lines[i]
    end
    return item
  end

  return left_lines[1] .. " " .. stringify_lines(right_lines)
end

local function build_pair_items(children, preserve_multiline)
  if #children == 0 or #children % 2 ~= 0 then
    return
  end

  local items = {}
  for i = 1, #children, 2 do
    local left_lines = node_text_lines(children[i])
    local right_lines = node_text_lines(children[i + 1])
    local item = compose_pair_item(left_lines, right_lines, preserve_multiline)
    if not item then
      return
    end
    items[#items + 1] = item
  end
  return items
end

local function is_binding_vector(tsnode)
  if tsnode:type() ~= "vec_lit" then
    return false
  end

  local parent = tsnode:parent()
  if not parent or parent:type() ~= "list_lit" or parent:named_child(1) ~= tsnode then
    return false
  end

  local head = parent:named_child(0)
  local head_text = head and normalize_node_text(head)
  return head_text and clojure_binding_forms[head_text] or false
end

local function build_clojure_items(tsnode, preserve_multiline)
  local children = named_children(tsnode)
  if tsnode:type() == "map_lit" or tsnode:type() == "ns_map_lit" then
    return build_pair_items(children, preserve_multiline) or build_generic_items(children, preserve_multiline)
  end
  if tsnode:type() == "vec_lit" and is_binding_vector(tsnode) then
    return build_pair_items(children, preserve_multiline) or build_generic_items(children, preserve_multiline)
  end
  return build_generic_items(children, preserve_multiline)
end

local function can_collapse_clojure_collection(tsnode)
  for child in tsnode:iter_children() do
    if child:extra() then
      return false
    end
    if child:named() then
      if child:type():match("comment") then
        return false
      end
    end
  end
  return true
end

local function collapse_collection_items(opening, closing, items)
  local replacement = {}
  local current_line = opening

  for _, item in ipairs(items) do
    local item_lines = type(item) == "table" and item or { item }
    local separator = current_line == opening and "" or " "
    local prefix_len = #current_line + #separator

    current_line = current_line .. separator .. item_lines[1]

    if #item_lines > 1 then
      replacement[#replacement + 1] = current_line
      local indent = (" "):rep(prefix_len)
      for i = 2, #item_lines do
        current_line = indent .. item_lines[i]
        if i < #item_lines then
          replacement[#replacement + 1] = current_line
        end
      end
    end
  end

  replacement[#replacement + 1] = current_line .. closing
  return replacement
end

local function maybe_format_clojure()
  vim.schedule(function()
    if vim.fn.executable("cljstyle") ~= 1 then
      return
    end
    local ok, conform = pcall(require, "conform")
    if not ok then
      return
    end
    pcall(function()
      conform.format({
        async = false,
        lsp_fallback = false,
        timeout_ms = 500,
        quiet = true,
      })
    end)
  end)
end

local function toggle_clojure_collection(tsnode)
  local opening, closing = collection_edges(tsnode)
  if opening == "" and closing == "" then
    return
  end

  local opts = {
    cursor = {},
    format = true,
    callback = maybe_format_clojure,
  }

  if ts_helpers.node_is_multiline(tsnode) then
    if not can_collapse_clojure_collection(tsnode) then
      return
    end
    local items = build_clojure_items(tsnode, true)
    if not items or vim.tbl_isempty(items) then
      return
    end
    return collapse_collection_items(opening, closing, items), opts
  end

  local items = build_clojure_items(tsnode, false)
  if not items or vim.tbl_isempty(items) then
    return
  end
  local replacement = vim.deepcopy(items)
  replacement[1] = opening .. replacement[1]
  replacement[#replacement] = replacement[#replacement] .. closing
  return replacement, opts
end

M.clojure = function()
  return {
    ["list_lit"] = { { toggle_clojure_collection, name = "Toggle Multiline" } },
    ["set_lit"] = { { toggle_clojure_collection, name = "Toggle Multiline" } },
    ["vec_lit"] = { { toggle_clojure_collection, name = "Toggle Multiline" } },
    ["map_lit"] = { { toggle_clojure_collection, name = "Toggle Multiline" } },
    ["ns_map_lit"] = { { toggle_clojure_collection, name = "Toggle Multiline" } },
  }
end

return M
