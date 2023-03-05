local opts = {
	only_current_line = true,
	eol = {
		right_align = true,
	},
}

return {
	"simrat39/inlay-hints.nvim",
	event = "BufReadPre",
	opts = opts,
}
