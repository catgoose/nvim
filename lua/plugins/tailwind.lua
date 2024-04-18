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
	--  BUG: 2024-04-18 - This plugin causes commentstring to be set to html for
	--  setup portion of vue sfc
	-- {
	-- 	"razak17/tailwind-fold.nvim",
	-- 	opts = {
	-- 		ft = {
	-- 			"html",
	-- 			"vue",
	-- 		},
	-- 		min_chars = 80,
	-- 	},
	-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
	-- 	ft = ft,
	-- },
}
