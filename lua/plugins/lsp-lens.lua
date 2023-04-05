local m = require("util").lazy_map

local opts = {
	enable = false,
	include_declaration = false,
}

return {
	"VidocqH/lsp-lens.nvim",
	opts = opts,
	event = "BufReadPre",
	keys = {
		m("<leader>dl", "LspLensToggle"),
	},
}
