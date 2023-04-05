local opts = {
	patterns = {
		html = {
			"element",
			"start_tag",
		},
	},
}

return {
	"nvim-treesitter/nvim-treesitter-context",
	opts = opts,
	event = "BufReadPre",
	enabled = false,
}
