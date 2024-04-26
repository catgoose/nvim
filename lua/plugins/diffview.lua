local m = require("util").lazy_map

return {
	"sindrets/diffview.nvim",
	config = true,
	cmd = { "DiffviewOpen" },
	keys = {
		m("<leader>do", [[DiffviewOpen]]),
		m("<leader>dq", [[DiffviewClose]]),
		m("<leader>dm", [[DiffviewPrompt]]),
	},
}
