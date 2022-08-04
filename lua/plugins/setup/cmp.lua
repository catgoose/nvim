local plugin = require("config.utils").require_plugin
local cmp = plugin("cmp")
local lspkind = plugin("lspkind")
local luasnip = plugin("luasnip")
local cmp_autopairs = plugin("nvim-autopairs.completion.cmp")

local comment_enable = function()
	local context = require("cmp.config.context")
	return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
end
local telescope_enable = function()
	local prompt = vim.bo.buftype == "prompt"
	return not prompt
end

cmp.setup({
	enabled = function()
		return comment_enable() and telescope_enable()
	end,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	view = {
		entries = { name = "custom", selection_order = "near_cursor" },
	},
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp", keyword_length = 2, group_index = 1 },
		{ name = "luasnip", keyword_length = 2, group_index = 1, option = { use_show_condition = false } },
		-- { name = "copilot", group_index = 1 },
		{ name = "nvim_lua", keyword_length = 2, group_index = 1 },
		{ name = "path", keyword_length = 3, group_index = 3 },
		{ name = "buffer", keyword_length = 3, group_index = 3 },
		{ name = "cmdline", keyword_length = 3, group_index = 3 },
		{ name = "treesitter", keyword_length = 4, group_index = 4 },
	}),
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			maxwidth = 50,
			before = function(entry, vim_item)
				entry = entry
				return vim_item
			end,
			menu = {
				nvim_lsp = "[LSP]",
				nvim_lua = "[LUA]",
				luasnip = "[SNIP]",
				buffer = "[BUF]",
				path = "[PATH]",
				cmdline = "[CMD]",
				treesitter = "[TS]",
				-- lab = "[LAB]",
			},
		}),
	},
	experimental = {
		native_menu = false,
		ghost_text = false, -- disable if using copilot.vim
	},
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer", keyword_length = 3 },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path", keyword_length = 3 },
		{ name = "cmdline", keyword_length = 3 },
	}),
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
