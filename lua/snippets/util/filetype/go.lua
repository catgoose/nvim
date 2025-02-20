local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local ts_locals = require("nvim-treesitter.locals")
local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

function M.in_func()
  -- local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  -- if not ok then
  --   return false
  -- end
  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then
    return false
  end
  local expr = current_node

  while expr do
    if expr:type() == "function_declaration" or expr:type() == "method_declaration" then
      return true
    end
    local parent = expr:parent()
    if not parent then
      return false
    end
    expr = parent
  end
  return false
end

function M.not_in_func()
  return not M.in_func()
end

local query_is_set = false

local function set_query()
  if query_is_set then
    return
  end
  query_is_set = true
  vim.treesitter.query.set(
    "go",
    "LuaSnip_Result",
    [[
      [
        (method_declaration result: (_) @id)
        (function_declaration result: (_) @id)
        (func_literal result: (_) @id)
      ]
  ]]
  )
end

M.go_err_snippet = function(args, _, _, spec)
  local err_name = args[1][1]
  local index = spec and spec.index or nil
  local msg = spec and spec[1] or ""
  if spec and spec[2] then
    err_name = err_name .. spec[2]
  end
  return ls.sn(index, {
    ls.c(1, {
      ls.sn(nil, fmt('fmt.Errorf("{}: %w", {})', { ls.i(1, msg), ls.t(err_name) })),
      -- ls.sn(nil, fmt('fmt.Errorf("{}", {}, {})', { ls.t(err_name), ls.i(1, msg), ls.i(2) })),
      ls.sn(
        nil,
        fmt(
          [[
  internal.GrpcError({},
  codes.{}, "{}", "{}", {})
        ]],
          {
            ls.t(err_name),
            ls.i(1, "Internal"),
            ls.i(2, "Description"),
            ls.i(3, "Field"),
            ls.i(4, "fields"),
          }
        )
      ),
      ls.t(err_name),
    }),
  })
end

local function transform(text, info)
  local string_sn = function(template, default)
    info.index = info.index + 1
    return ls.sn(info.index, fmt(template, ls.i(1, default)))
  end
  local new_sn = function(default)
    return string_sn("{}", default)
  end

  -- cutting the name if exists.
  if text:find([[^[^\[]*string$]]) then
    text = "string"
  elseif text:find("^[^%[]*map%[[^%]]+") then
    text = "map"
  elseif text:find("%[%]") then
    text = "slice"
  elseif text:find([[ ?chan +[%a%d]+]]) then
    return ls.t("nil")
  end

  -- separating the type from the name if exists.
  local type = text:match([[^[%a%d]+ ([%a%d]+)$]])
  if type then
    text = type
  end

  if text == "int" or text == "int64" or text == "int32" then
    return new_sn("0")
  elseif text == "float32" or text == "float64" then
    return new_sn("0")
  elseif text == "error" then
    if not info then
      return ls.t("err")
    end

    info.index = info.index + 1
    return M.go_err_snippet({ { info.err_name } }, nil, nil, { index = info.index })
  elseif text == "bool" then
    info.index = info.index + 1
    return ls.c(info.index, { ls.i(1, "false"), ls.i(2, "true") })
  elseif text == "string" then
    return string_sn('"{}"', "")
  elseif text == "map" or text == "slice" then
    return ls.t("nil")
  elseif string.find(text, "*", 1, true) then
    return new_sn("nil")
  end

  text = text:match("[^ ]+$")
  if text == "context.Context" then
    text = "context.Background()"
  else
    -- when the type is concrete
    text = text .. "{}"
  end

  return ls.t(text)
end

local get_node_text = vim.treesitter.get_node_text

local handlers = {
  parameter_list = function(node, info)
    local result = {}

    local count = node:named_child_count()
    for idx = 0, count - 1 do
      table.insert(result, transform(get_node_text(node:named_child(idx), 0), info))
      if idx ~= count - 1 then
        table.insert(result, ls.t({ ", " }))
      end
    end

    return result
  end,

  type_identifier = function(node, info)
    local text = get_node_text(node, 0)
    return { transform(text, info) }
  end,
}

local function return_value_nodes(info)
  set_query()
  local cursor_node = ts_utils.get_node_at_cursor()
  if not cursor_node then
    return
  end
  local scope_tree = ts_locals.get_scope_tree(cursor_node, 0)

  local function_node
  for _, scope in ipairs(scope_tree) do
    if
      scope:type() == "function_declaration"
      or scope:type() == "method_declaration"
      or scope:type() == "method_declaration"
      or scope:type() == "func_literal"
    then
      function_node = scope
      break
    end
  end

  if not function_node then
    return
  end

  local query = vim.treesitter.query.get("go", "LuaSnip_Result")
  if query then
    for _, node in query:iter_captures(function_node, 0) do
      if handlers[node:type()] then
        return handlers[node:type()](node, info)
      end
    end
  end
  return ls.t({ "" })
end

M.make_default_return_nodes = function()
  local info = { index = 0, err_name = "nil" }

  return ls.sn(nil, return_value_nodes(info))
end

M.make_return_nodes = function(args)
  local info = { index = 0, err_name = args[1][1] }

  return ls.sn(nil, return_value_nodes(info))
end

function M.get_receiver()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
  local query_string = [[
    (method_declaration
      receiver: (parameter_list 
        (parameter_declaration) @receiver_param)
      name: (field_identifier) @method_name)
  ]]
  -- Parse the query
  local lang = vim.treesitter.language.get_lang("go")
  if not lang then
    return
  end
  local query = vim.treesitter.query.parse(lang, query_string)
  -- Get the root of the syntax tree
  local parser = vim.treesitter.get_parser(bufnr, "go")
  if not parser then
    return
  end
  local tree = parser:parse()[1]
  local root = tree:root()
  local best_match = nil
  local best_row = 0
  for _, match, _ in query:iter_matches(root, bufnr, 0, cursor_row) do
    for id, nodes in pairs(match) do
      local name = query.captures[id]
      if name == "receiver_param" then
        for _, node in ipairs(nodes) do
          local start_row = node:range() -- Get start position
          if start_row < cursor_row and start_row > best_row then
            local text = vim.treesitter.get_node_text(node, bufnr)
            if text ~= nil then
              best_match = node
              best_row = start_row
            end
          end
        end
      end
    end
  end
  -- If we found a match, return its text
  if best_match then
    local receiver_text = vim.treesitter.get_node_text(best_match, bufnr)
    return receiver_text
  end
end

return M
