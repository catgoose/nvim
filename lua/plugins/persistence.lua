local const = require("config.constants").const

return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = {
		dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
		options = const.opt.sessionoptions_tbl,
		pre_save = nil,
		save_empty = false,
	},
}
