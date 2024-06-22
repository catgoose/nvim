local fn = vim.fn

local M = {}

local is_not_comment = function()
  local context = require("cmp.config.context")
  return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
end
local is_not_buftype = function()
  local bt = vim.bo.buftype
  local exclude_bt = {
    "prompt",
    "nofile",
  }
  for _, v in pairs(exclude_bt) do
    if bt == v then
      return false
    end
  end
  return true
end
local is_not_filetype = function()
  local ft = vim.bo.filetype
  local exclude_ft = {
    "neorepl",
    "neoai-input",
    "NeogitCommitMessage",
    "oil",
  }
  for _, v in pairs(exclude_ft) do
    if ft == v then
      return false
    end
  end
  return true
end
local is_not_luasnip = function()
  local path = fn.expand("%:p")
  if not path then
    return true
  end
  return not path:find(".*/nvim/lua/snippets/.*%.lua")
end

function M.is_enabled()
  return is_not_comment() and is_not_buftype() and is_not_filetype() and is_not_luasnip()
end

return M
