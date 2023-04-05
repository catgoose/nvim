local opts = {
	automatic_installation = true,
}

return {
	"jay-babu/mason-null-ls.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}
