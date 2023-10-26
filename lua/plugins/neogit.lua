local m = require("util").lazy_map

local opts = {
	disable_insert_on_commit = false,
	integrations = {
		telescope = true,
	},
}

return {
	"NeogitOrg/neogit",
	opts = opts,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"sindrets/diffview.nvim",
		"ibhagwan/fzf-lua",
	},
	cmd = { "Neogit" },
	keys = {
		m("<leader>go", "Neogit"),
		m("<leader>gl", "Neogit kind=vsplit"),
		m("<leader>gc", "Neogit commit"),
	},
}
