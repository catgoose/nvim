require("config.utils").plugin_setup("aerial", {
	on_attach = function(bufnr)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>a", "<cmd>AerialToggle!<CR>", {})
		vim.api.nvim_buf_set_keymap(bufnr, "n", "H", "<cmd>AerialPrev<CR>", {})
		vim.api.nvim_buf_set_keymap(bufnr, "n", "L", "<cmd>AerialNext<CR>", {})
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>H", "<cmd>AerialPrevUp<CR>", {})
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>L", "<cmd>AerialNextUp<CR>", {})
	end,
	default_direction = "float",
})
