local m = require("util").lazy_map

local opts = {
	autoresize = {
		enable = false,
		quickfixheight = 60,
	},
	excluded_buftypes = { "nofile", "prompt", "popup", "quickfix" },
	excluded_filetypes = { "harpoon", "dbui", "sql" },
	compatible_filetrees = { "neo-tree" },
}

return {
	"nvim-focus/focus.nvim",
	config = function()
		require("focus").setup(opts)
		local ignore_filetypes = { "harpoon" }
		local ignore_buftypes = { "nofile", "prompt", "popup", "quickfix" }

		local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

		vim.api.nvim_create_autocmd("WinEnter", {
			group = augroup,
			callback = function(_)
				if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
					vim.b.focus_disable = true
				end
			end,
			desc = "Disable focus autoresize for BufType",
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = augroup,
			callback = function(_)
				if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
					vim.b.focus_disable = true
				end
			end,
			desc = "Disable focus autoresize for FileType",
		})

		vim.cmd("FocusEqualise")
	end,
	cmd = {
		"FocusSplitDown",
		"FocusSplitRight",
		"FocusMaximise",
		"FocusEqualise",
		"FocusToggle",
	},
	keys = {
		m("<leader>ss", [[FocusSplitDown]]),
		m("<leader>sv", [[FocusSplitRight]]),
		m("<leader>sm", [[FocusMaximise]]),
		m("<leader>se", [[FocusEqualise]]),
		m("<leader>st", [[FocusToggle]]),
	},
}
