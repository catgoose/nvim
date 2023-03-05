local opts = {
	auto_enable = true,
	auto_resize_height = true,
	func_map = {
		open = "<cr>",
		openc = "o",
		vsplit = "v",
		split = "s",
		fzffilter = "f",
		pscrollup = "<C-u>",
		pscrolldown = "<C-d>",
		ptogglemode = "F",
		filter = "n",
		filterr = "N",
	},
}

return {
	"kevinhwang91/nvim-bqf",
	opts = opts,
	ft = "qf",
	dependencies = {
		"junegunn/fzf",
		build = function()
			vim.fn["fzf#install"]()
		end,
	},
}
