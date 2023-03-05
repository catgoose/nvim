local config = function()
	require("lspkind").init({
		mode = "symbol_text",
		preset = "default",
		symbol_map = {
			Text = "",
			Method = "",
			Function = "",
			Constructor = "",
			Field = "ﰠ",
			Variable = "",
			Class = "ﴯ",
			Interface = "",
			Module = "",
			Property = "ﰠ",
			Unit = "塞",
			Value = "",
			Enum = "",
			Keyword = "",
			Snippet = "",
			Color = "",
			File = "",
			Reference = "",
			Folder = "",
			EnumMember = "",
			Constant = "",
			Struct = "פּ",
			Event = "",
			Operator = "",
			TypeParameter = "",
			Copilot = "",
		},
	})
end

return {
	"onsails/lspkind-nvim",
	config = config,
	event = "BufReadPre",
	dependencies = {
		{
			"hrsh7th/cmp-nvim-lsp",
			dependencies = {
				"L3MON4D3/LuaSnip",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-emoji",
				"ray-x/cmp-treesitter",
				"saadparwaiz1/cmp_luasnip",
				"roobert/tailwindcss-colorizer-cmp.nvim",
				"rcarriga/cmp-dap",
			},
		},
		"hrsh7th/nvim-cmp",
	},
}
