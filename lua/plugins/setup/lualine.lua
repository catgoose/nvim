local utils = require("config.utils")
local navic = utils.require_plugin("nvim-navic")

utils.plugin_setup("lualine", {
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = {
			{ navic.get_location, cond = navic.is_available },
		},
		lualine_x = {
			{
				"diagnostics",
				sources = { "nvim_lsp", "nvim_diagnostic" },
				sections = { "error", "warn", "info", "hint" },
				diagnostics_color = {
					error = "DiagnosticError",
					warn = "DiagnosticWarn",
					info = "DiagnosticInfo",
					hint = "DiagnosticHint",
				},
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
				colored = true,
				update_in_insert = true,
				always_visible = false,
			},
		},
		lualine_y = {
			{
				"filetype",
				colored = true,
				icon_only = true,
			},
		},
		lualine_z = { "progress", "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		-- lualine_a = {
		-- 	-- {
		-- 	-- 	"buffers",
		-- 	-- 	mode = 2,
		-- 	-- },
		-- },
		-- lualine_b = {},
		-- lualine_c = {},
		-- lualine_x = {},
		-- lualine_y = {},
		-- lualine_z = {},
	},
	extensions = { "fzf", "man", "toggleterm" },
})
