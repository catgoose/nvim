local m = require("util").lazy_map

local opts = {
	disable_insert_on_commit = false,
	commit_editor = {
		kind = "vsplit",
	},
}

return {
	"NeogitOrg/neogit",
	opts = opts,
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"ibhagwan/fzf-lua",
	},
	cmd = { "Neogit" },
	keys = {
		m("<leader>g", "Neogit"),
		m("<leader>gl", "Neogit kind=vsplit"),
	},
}
