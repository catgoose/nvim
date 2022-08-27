local ls = require("luasnip")
local M = {}

M.ft = function()
	return vim.bo.filetype
end

M.comment = function()
	local ft = M.ft()
	if ft == "lua" then
		return "-- "
	end
	if ft == "typescript" or "javascript" then
		return "// "
	end
	if ft == "sh" then
		return "# "
	end
	if ft == "html" then
		return "<!-- "
	end
end

M.today = function()
	return os.date("%Y-%m-%d")
end

M.capitalize = function(str)
	return str:sub(1, 1):upper() .. str:sub(2)
end

return M
