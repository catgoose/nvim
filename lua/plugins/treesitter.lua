local config = function()
	local opts = {
		ensure_installed = {
			"awk",
			"bash",
			"cmake",
			"cpp",
			"css",
			"dockerfile",
			"fish",
			"help",
			"html",
			"http",
			"gitignore",
			"javascript",
			"jq",
			"json",
			"jsonc",
			"lua",
			"make",
			"markdown",
			"markdown_inline",
			"python",
			"regex",
			"ruby",
			"rust",
			"scss",
			"sql",
			"toml",
			"typescript",
			"vim",
			"yaml",
		},
		highlight = {
			enable = true,
		},
		matchup = {
			enable = true,
		},
		autotag = {
			enable = true,
		},
		{
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		},
		textobjects = {
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]f"] = "@function.outer",
					["]b"] = "@parameter.outer",
					["]d"] = "@block.inner",
					["]e"] = "@function.inner",
					["]a"] = "@attribute.inner",
					["]c"] = "@property_call",
				},
				goto_next_end = {
					["]F"] = "@function.outer",
					["]B"] = "@parameter.outer",
					["]D"] = "@block.inner",
					["]E"] = "@function.inner",
					["]A"] = "@attribute.inner",
					["]C"] = "@property_call",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[b"] = "@parameter.outer",
					["[d"] = "@block.inner",
					["[e"] = "@function.inner",
					["[a"] = "@attribute.inner",
					["[c"] = "@property_call",
				},
				goto_previous_end = {
					["[F"] = "@function.outer",
					["[B"] = "@parameter.outer",
					["[D"] = "@block.inner",
					["[E"] = "@function.inner",
					["[A"] = "@attribute.inner",
					["[C"] = "@property_call",
				},
			},
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@call.outer",
					["ic"] = "@call.inner",
					["aC"] = "@class.outer",
					["iC"] = "@class.inner",
					["ib"] = "@parameter.inner",
					["ab"] = "@parameter.outer",
					["iB"] = "@block.inner",
					["aB"] = "@block.outer",
					["id"] = "@block.inner",
					["ad"] = "@block.outer",
					["il"] = "@loop.inner",
					["al"] = "@loop.outer",
					["ia"] = "@attribute.inner",
					["aa"] = "@attribute.outer",
				},
			},
		},
		textsubjects = {
			enable = true,
			prev_selection = ",",
			keymaps = {
				["."] = "textsubjects-smart",
				[";"] = "textsubjects-container-outer",
				["i;"] = "textsubjects-container-inner",
			},
		},
	}

	require("nvim-treesitter.configs").setup(opts)

	vim.treesitter.language.register("markdown", "octo")
end

return {
	"nvim-treesitter/nvim-treesitter",
	config = config,
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{
			"elgiano/nvim-treesitter-angular",
			branch = "topic/jsx-fix",
		},
		"nvim-treesitter/nvim-treesitter-textobjects",
		"RRethy/nvim-treesitter-textsubjects",
		"windwp/nvim-ts-autotag",
		"JoosepAlviste/nvim-ts-context-commentstring",
		"nvim-treesitter/playground",
		"CKolkey/ts-node-action",
	},
}
