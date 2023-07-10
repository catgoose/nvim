local config = function()
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	local luasnip = require("luasnip")
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	local enabled = require("util.cmp").is_cmp_enabled
	local cmp_tailwind = require("tailwindcss-colorizer-cmp")

	cmp.setup({
		enabled = function()
			return enabled()
		end,
		preselect = cmp.PreselectMode.Item,
		keyword_length = 2,
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
				behavior = cmp.confirm({ select = true }),
				select = true,
			}),
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-b>"] = cmp.mapping.scroll_docs(-5),
			["<C-f>"] = cmp.mapping.scroll_docs(5),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-q>"] = cmp.mapping.abort(),
		}),
		sources = cmp.config.sources({
			{
				name = "luasnip",
				group_index = 1,
				option = { use_show_condition = true },
			},
			{
				name = "nvim_lsp",
				group_index = 2,
			},
			{
				name = "nvim_lua",
				group_index = 2,
			},
			{
				name = "crates",
				group_index = 2,
			},
			{
				name = "treesitter",
				keyword_length = 3,
				group_index = 3,
			},
			{
				name = "path",
				keyword_length = 3,
				group_index = 3,
			},
			{
				name = "buffer",
				keyword_length = 3,
				group_index = 4,
				option = {
					get_bufnrs = function()
						local bufs = {}
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							bufs[vim.api.nvim_win_get_buf(win)] = true
						end
						return vim.tbl_keys(bufs)
					end,
				},
			},
			{
				name = "emoji",
				keyword_length = 2,
				group_index = 5,
			},
			{
				name = "nerdfont",
				keyword_length = 2,
				group_index = 5,
			},
		}),
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol_text",
				maxwidth = 50,
				-- before = function(entry, vim_item)
				-- 	entry = entry
				-- 	return vim_item
				-- end,
				menu = {
					nvim_lsp = "[LSP]",
					nvim_lua = "[LUA]",
					luasnip = "[SNIP]",
					buffer = "[BUF]",
					path = "[PATH]",
					treesitter = "[TREE]",
				},
				before = cmp_tailwind.formatter,
			}),
		},
		sorting = {
			priority_weight = 2,
			comparators = {
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				cmp.config.compare.recently_used,
				cmp.config.compare.locality,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},
		},
		experimental = {
			native_menu = false,
			ghost_text = false,
		},
	})
	---@diagnostic disable-next-line: undefined-field
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return {
	"hrsh7th/nvim-cmp",
	config = config,
	event = "InsertEnter",
}
