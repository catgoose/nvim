local dev = true
local e = vim.tbl_extend

local opts = {
	auto_imports = true,
	components = true,
	filetypes = { "vue" },
	detection = {
		nuxt = function()
			return vim.fn.glob(".nuxt/") ~= ""
		end,
		vue3 = function()
			return vim.fn.filereadable("vite.config.ts") == 1
		end,
		priority = { "nuxt", "vue3" },
	},
}

local plugin = {
	keys = {
		{
			"<leader>z",
			function()
				vim.cmd([[Lazy reload vue-goto-definition.nvim]])
			end,
		},
	},
	opts = opts,
	enabled = true,
}

if dev == true then
	return e("keep", plugin, {
		dir = "~/git/vue-goto-definition.nvim",
		lazy = false,
	})
else
	return e("keep", plugin, {
		"catgoose/vue-goto-definition.nvim",
		event = "BufReadPre",
	})
end
