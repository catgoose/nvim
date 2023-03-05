local m = require("util").lazy_map

return {
	"rcarriga/nvim-dap-ui",
	config = true,
	keys = {
		m("<leader>n", [[lua require("dapui").toggle()]]),
	},
	dependencies = {
		"mfussenegger/nvim-dap",
	},
}
