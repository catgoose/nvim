local opts = {
	affixes = {
		remote = { window = "r", cross_window = "R" },
		magnetic = { window = "m", cross_window = "M" },
	},
	yank_paste = false,
}

return {
	"ggandor/leap-spooky.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "ggandor/leap.nvim",
}
