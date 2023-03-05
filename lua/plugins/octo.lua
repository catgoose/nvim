local m = require("util").lazy_map

local opts = {
	ssh_aliases = {
		["github.com"] = "github.com",
	},
}

return {
	"pwntester/octo.nvim",
	opts = opts,
	cmd = "Octo",
	keys = {
		m("<leader>to", "Octo actions"),
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"kyazdani42/nvim-web-devicons",
	},
}
