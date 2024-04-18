local ft = { "vue", "html" }
return {
	{
		"MaximilianLloyd/tw-values.nvim",
		opts = {
			focus_preview = true,
		},
		lazy = true,
		ft = ft,
	},
	{
		"razak17/tailwind-fold.nvim",
		opts = {
			ft = {
				"html",
				"vue",
			},
			min_chars = 80,
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = ft,
	},
}
