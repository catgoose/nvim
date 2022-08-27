local utils = require("config.utils")

utils.require_plugin("scrollbar").setup({
	show_in_active_only = true,
	handle = {
		text = " ",
		color = nil,
		cterm = nil,
		highlight = "Scrollbar",
		hide_if_all_visible = true,
	},
})
utils.require_plugin("scrollbar.handlers.search").setup()
