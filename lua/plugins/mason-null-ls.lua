local opts = {
	automatic_installation = true,
}

return {
	"jay-babu/mason-null-ls.nvim",
	opts = opts,
	event = "BufReadPre",
	dependecies = "williamboman/mason.nvim",
}
