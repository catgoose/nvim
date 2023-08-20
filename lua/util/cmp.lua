local fn = vim.fn

M = {}

local is_not_comment = function()
	local context = require("cmp.config.context")
	return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
end
local is_not_prompt = function()
	local prompt = vim.bo.buftype == "prompt"
	return not prompt
end
local is_not_filetype = function()
	local ft = vim.bo.filetype
	local exclude_ft = {
		"neorepl",
		"neoai-input",
	}
	for _, v in pairs(exclude_ft) do
		if ft == v then
			return false
		end
	end
	return true
end
local is_not_luasnip = function()
	return not fn.expand("%:p"):find(".*/nvim/lua/snippets/.*%.lua")
end
local is_dap_buffer = function()
	-- return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
	return false
end

---@diagnostic disable-next-line: duplicate-set-field
M.is_cmp_enabled = function()
	return (is_not_comment() and is_not_prompt() and is_not_filetype() and is_not_luasnip()) or is_dap_buffer()
end

return M
