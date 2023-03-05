local m = require("util").lazy_map

return {
	"mfussenegger/nvim-dap",
	event = "BufReadPre",
	keys = {
		m("<leader>dc", [[DapContinue]]),
		m("<leader>db", [[DapToggleBreakpoint]]),
		m("<leader>di", [[DapStepInto]]),
		m("<leader>do", [[DapStepOut]]),
		m("<leader>dl", [[DapStepOver]]),
	},
}
