local M = {}

function M.lua_require(arg)
  local parts = vim.split(arg[1][1], ".", { plain = true })
  return parts[#parts] or ""
end

return M
