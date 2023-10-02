local m = require("util").lazy_map

return {
	"sindrets/diffview.nvim",
	config = true,
	cmd = { "DiffviewOpen" },
	keys = {
		m("<leader>dv", [[DiffviewOpen]]),
		m("<leader>dc", [[DiffviewClose]]),
	},
}
