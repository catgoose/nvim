local M = {}

function M.nest_method_args(_, snip, _)
  local ts_query = "(required_parameter pattern: (identifier) @param )"
  local method_args = ""
  local pos_begin = snip.nodes[3].mark:pos_begin()
  local pos_end = snip.nodes[3].mark:pos_end()
  local parser = vim.treesitter.get_parser(0, "typescript")
  local tstree = parser:parse()[1]
  local node =
    tstree:root():named_descendant_for_range(pos_begin[1], pos_begin[2], pos_end[1], pos_end[2])

  if node == nil then
    return ""
  end
  for child in node:iter_children() do
    local query = vim.treesitter.query.parse("typescript", ts_query)
    ---@diagnostic disable-next-line: missing-parameter
    for _, arg in query:iter_captures(child, 0) do
      method_args = method_args .. vim.treesitter.get_node_text(arg, 0) .. ", "
    end
  end

  if method_args ~= "" then
    method_args = method_args:sub(1, -3)
  end
  return method_args
end

function M.nest_classname()
  local ts_query = "(class_declaration name: (type_identifier) @class_name)"
  local parser = vim.treesitter.get_parser(0, "typescript")
  local tstree = parser:parse()[1]
  local node = tstree:root()
  local query = vim.treesitter.query.parse("typescript", ts_query)
  ---@diagnostic disable-next-line: missing-parameter
  for _, class_name in query:iter_captures(node, 0) do
    return vim.treesitter.get_node_text(class_name, 0)
  end
end

return M
