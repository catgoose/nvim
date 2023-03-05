local u = require("util")
local m = u.lazy_map
local width, height = u.screen_scale({ width = 1 / 2, height = 1 / 3 })
local opts = {
	menu = {
		width = width,
		height = height,
	},
	save_on_toggle = true,
	save_on_change = true,
	enter_on_sendcmd = true,
	tmux_autoclose_windows = true,
	excluded_filetypes = { "harpoon" },
	mark_branch = false,
}

return {
	"ThePrimeagen/harpoon",
	opts = opts,
	keys = {
		m("<leader>a", [[lua require("harpoon.mark").add_file()]], { "n", "x" }),
		m("<leader>l", [[lua require("harpoon.ui").toggle_quick_menu()]], { "n", "x" }),
		m("]]", [[lua require("harpoon.ui").nav_next()]], { "n", "x" }),
		m("[[", [[lua require("harpoon.ui").nav_prev()]], { "n", "x" }),
	},
	dependencies = "nvim-lua/plenary.nvim",
}
