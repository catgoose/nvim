local m = require("util").lazy_map

local config = function()
	local ls = require("luasnip")
	local types = require("luasnip.util.types")

	ls.config.set_config({
		history = false,
		updateevents = "TextChanged,TextChangedI",
		delete_check_events = "TextChanged",
		enable_autosnippets = false,
		ext_opts = {
			[types.choiceNode] = {
				active = {
					virt_text = { { " <- Choice", "Title" } },
				},
			},
		},
		ext_base_prio = 300,
		ext_prio_increase = 1,
		ft_func = function()
			return vim.split(vim.bo.filetype, ".", { plain = true })
		end,
	})

	vim.keymap.set({ "i", "s" }, "<c-k>", function()
		if ls.expand_or_jumpable() then
			ls.expand_or_jump()
		end
	end, { silent = true })

	vim.keymap.set({ "i", "s" }, "<c-j>", function()
		if ls.jumpable(-1) then
			ls.jump(-1)
		end
	end, { silent = true })

	vim.keymap.set("i", "<c-l>", function()
		if ls.choice_active() then
			ls.change_choice(1)
		end
	end)

	require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
end

return {
	"L3MON4D3/LuaSnip",
	config = config,
	event = "InsertEnter",
	keys = {
		m("<leader>sn", [[lua require("luasnip.loaders.from_lua").edit_snippet_files()]]),
	},
}
