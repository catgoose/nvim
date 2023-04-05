local cmd, api = vim.cmd, vim.api

local M = {}

M.toggleterm_opts = function(added_opts)
	local toggleterm_opts = {
		auto_scroll = true,
		direction = "float",
		float_opts = {
			border = "curved",
			width = 145,
			height = 32,
			winblend = 10,
		},
		winbar = {
			enabled = false,
		},
		shade_terminals = false,
		hide_numbers = false,
		on_open = function(term)
			cmd.startinsert()
			api.nvim_buf_set_keymap(term.bufnr, "n", "q", [[<cmd>close<cr>]], { noremap = true, silent = true })
		end,
		on_close = function() end,
	}
	if not added_opts then
		return toggleterm_opts
	end
	return vim.tbl_deep_extend("force", toggleterm_opts, added_opts)
end

return M
