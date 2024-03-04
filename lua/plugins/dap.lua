local m = require("util").lazy_map

return {
	-- {
	"mfussenegger/nvim-dap",
	event = "BufReadPre",
	-- keys = {
	-- 	m("<leader>dc", [[DapContinue]]),
	-- 	m("<leader>db", [[DapToggleBreakpoint]]),
	-- 	m("<leader>di", [[DapStepInto]]),
	-- 	m("<leader>do", [[DapStepOut]]),
	-- 	m("<leader>dl", [[DapStepOver]]),
	-- },
	enabled = false,
	-- {
	-- 	"theHamsta/nvim-dap-virtual-text",
	-- 	config = true,
	-- 	dependencies = {
	-- 		"mfussenegger/nvim-dap",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	event = "BufReadPre",
	-- },
	-- {
	-- 	"ofirgall/goto-breakpoints.nvim",
	-- 	event = "BufReadPre",
	-- 	keys = {
	-- 		m("]r", [[lua require('goto-breakpoints').next()]]),
	-- 		m("[r", [[lua require('goto-breakpoints').prev()]]),
	-- 	},
	-- 	dependencies = "mfussenegger/nvim-dap",
	-- },
	-- },
}
