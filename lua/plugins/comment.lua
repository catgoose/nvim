local opts = {
	padding = true,
	sticky = true,
	ignore = "^$",
	toggler = {
		line = "gcc",
		block = "gbc",
	},
	opleader = {
		line = "gc",
		block = "gb",
	},
	extra = {
		above = "gcO",
		below = "gco",
		eol = "gcA",
	},
	mappings = {
		basic = true,
		extra = true,
		extended = false,
	},
	-- prehook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	prehook = nil,
	post_hook = nil,
}

return {
	"numToStr/Comment.nvim",
	opts = opts,
	event = "BufReadPre",
	dependencies = "nvim-treesitter/nvim-treesitter",
}
