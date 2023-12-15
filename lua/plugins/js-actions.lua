local m = require("util").lazy_map

local ft = {
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"vue",
}

return {
	{
		"llllvvuu/nvim-js-actions",
		ft = ft,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = {
			m("<leader>A", [[lua require('nvim-js-actions').js_arrow_fn.toggle()]]),
		},
	},
}
