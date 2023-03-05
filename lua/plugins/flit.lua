local opts = {
	keys = { f = "f", F = "F", t = "t", T = "T" },
	labeled_modes = "nvo",
	multiline = true,
	opts = {},
}

return {
	"ggandor/flit.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "ggandor/leap.nvim",
}
