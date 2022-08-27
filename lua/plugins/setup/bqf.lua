require("config.utils").plugin_setup("bqf", {
	auto_enable = true,
	auto_resize_height = true,
	func_map = {
		openc = "o",
		vsplit = "v",
		split = "s",
		fzffilter = "f",
		pscrollup = "<C-u>",
		pscrolldown = "<C-d>",
		ptogglemode = "F",
		filter = "n",
		filterr = "N",
	},
})
