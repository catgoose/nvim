local ufo_u = require("util.ufo")
local const = require("config.constants").const

return {
	-- "folke/persistence.nvim",
	--  NOTE: 2024-04-13 - Using fork to allow for post_load hook until PR is
	--  merged: https://github.com/folke/persistence.nvim/pull/24
	"5c077m4n/persistence.nvim",
	event = "BufReadPre",
	opts = {
		dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
		options = const.opt.sessionoptions_tbl,
		pre_save = nil,
		save_empty = false,
		post_load = function()
			ufo_u.set_opts()
		end,
	},
}
