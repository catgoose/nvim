require("config.utils").plugin_setup("harpoon", {
	menu = {
		width = vim.fn.round(vim.api.nvim_win_get_width(0) / 2),
		height = vim.fn.round(vim.api.nvim_win_get_height(0) / 2),
	},
	save_on_toggle = true,
	save_on_change = true,
	enter_on_sendcmd = false,
	tmux_autoclose_windows = false,
	excluded_filetypes = { "harpoon" },
	mark_branch = true,
})
