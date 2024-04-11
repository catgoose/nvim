local opts = {
	automatic_installation = true,
}

return {
	"jay-babu/mason-null-ls.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = {
		"williamboman/mason.nvim",
		"nvimtools/none-ls.nvim",
	},
	enabled = false,
}
