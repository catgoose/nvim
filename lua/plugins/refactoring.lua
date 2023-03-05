local opts = {
	prompt_func_return_type = {
		go = false,
		java = false,
		cpp = false,
		c = false,
		h = false,
		hpp = false,
		cxx = false,
	},
	prompt_func_param_type = {
		go = false,
		java = false,
		cpp = false,
		c = false,
		h = false,
		hpp = false,
		cxx = false,
	},
	printf_statements = {},
	print_var_statements = {},
}

local config = function()
	local map = vim.api.nvim_set_keymap
	local map_opts = { noremap = true, silent = true, expr = false }
	map("v", "<leader>rr", ":lua require('refactoring').select_refactor()<CR>", map_opts)
	-- map("v", "<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], map_opts)
	-- map("v", "<leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], map_opts)
	-- map("v", "<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], map_opts)
	-- map("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], map_opts)
	-- map("n", "<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]], map_opts)
	-- map("n", "<leader>rbf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]], map_opts)
	-- map("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], map_opts)
end

return {
	"ThePrimeagen/refactoring.nvim",
	opts = opts,
	config = config,
	event = "BufReadPre",
}
