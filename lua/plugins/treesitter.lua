local m = require("util").lazy_map
local k = vim.keymap.set

local config = function()
	local opts = {
		ensure_installed = {
			"bash",
			"cpp",
			"css",
			"dockerfile",
			"fish",
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
					["]s"] = "@this_method_call",
					["]c"] = "@method_object_call",
					["]o"] = "@object_declaration",
					["]k"] = "@object_key",
					["]v"] = "@object_value",
					["]w"] = "@method_parameter",
				},
				goto_next_end = {
					["]F"] = "@function.outer",
					["]B"] = "@parameter.outer",
					["]D"] = "@block.inner",
					["]E"] = "@function.inner",
					["]A"] = "@attribute.inner",
					["]S"] = "@this_method_call",
					["]C"] = "@method_object_call",
					["]O"] = "@object_declaration",
					["]K"] = "@object_key",
					["]V"] = "@object_value",
					["]W"] = "@method_parameter",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[b"] = "@parameter.outer",
					["[d"] = "@block.inner",
					["[e"] = "@function.inner",
					["[a"] = "@attribute.inner",
					["[s"] = "@this_method_call",
					["[c"] = "@method_object_call",
					["[o"] = "@object_declaration",
					["[k"] = "@object_key",
					["[v"] = "@object_value",
					["[w"] = "@method_parameter",
				},
				goto_previous_end = {
					["[F"] = "@function.outer",
					["[B"] = "@parameter.outer",
					["[D"] = "@block.inner",
					["[E"] = "@function.inner",
					["[A"] = "@attribute.inner",
					["[S"] = "@this_method_call",
					["[C"] = "@method_object_call",
					["[O"] = "@object_declaration",
					["[K"] = "@object_key",
					["[V"] = "@object_value",
					["[W"] = "@method_parameter",
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
		playground = {
			enable = true,
			disable = {},
			updatetime = 25,
			persist_queries = true,
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},
		query_linter = {
			enable = true,
			use_virtual_text = true,
			lint_events = {
				"BufWrite",
				"CursorHold",
			},
		},
	}

	require("nvim-treesitter.configs").setup(opts)

	vim.treesitter.language.register("markdown", "octo")

	local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
	k({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
	k({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
	k({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
	k({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
	k({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
	k({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
end

return {
	{
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
			"CKolkey/ts-node-action",
			"nvim-treesitter/playground",
			"nvim-treesitter/nvim-treesitter-context",
			{
				"nvim-treesitter/playground",
				cmd = "TSPlaygroundToggle",
				keys = {
					m("<leader>tp", [[TSPlaygroundToggle]]),
				},
			},
		},
	},
}
