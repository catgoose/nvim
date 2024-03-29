local m = require("util").lazy_map

local opts = {
	disable_line_numbers = false,
	integrations = {
		diffview = true,
		telescope = true,
	},
}

return {
	"NeogitOrg/neogit",
	opts = opts,
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
	},
	cmd = { "Neogit" },
	keys = {
		m("<leader>G", "Neogit"),
		m("<leader>gl", "Neogit kind=vsplit"),
	},
}
