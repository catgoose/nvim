local opts = {
	null_ls = {
		enabled = true,
		name = "crates.nvim",
	},
}

return {
	"saecki/crates.nvim",
	event = { "BufRead Cargo.toml" },
	dependencies = "nvim-lua/plenary.nvim",
	opts = opts,
}
