local c = require("config.colors")

local overrides = function(colors)
	return {
		CursorLine = {
			bold = true,
			italic = true,
		},
		FoldColumn = {
			fg = colors.palette.dragonBlue,
		},
		IlluminatedCurWord = {
			italic = true,
		},
		IlluminatedWordText = {
			link = "CursorLine",
			italic = true,
		},
		IlluminatedWordRead = {
			link = "CursorLine",
			italic = true,
		},
		IlluminatedWordWrite = {
			link = "CursorLine",
			italic = true,
		},
		UfoFoldedVirtText = {
			bg = colors.palette.sumiInk4,
			fg = colors.palette.springViolet1,
			italic = true,
			bold = true,
		},
		StatusColumnFoldClosed = {
			fg = colors.palette.springViolet1,
			bold = false,
		},
		DashboardHeader = {
			fg = colors.palette.autumnRed,
			bg = colors.palette.sumiInk3,
		},
		DashboardIcon = {
			fg = colors.palette.springBlue,
			bg = colors.palette.sumiInk3,
		},
		DashboardDesc = {
			fg = colors.palette.lightBlue,
			bg = colors.palette.sumiInk3,
			italic = true,
		},
		DashboardKey = {
			fg = colors.palette.oniViolet,
			bg = colors.palette.sumiInk3,
			bold = true,
		},
	}
end

local config = function()
	require("kanagawa").setup({
		undercurl = true,
		commentStyle = { italic = true },
		functionStyle = {},
		keywordStyle = { italic = true },
		statementStyle = { bold = true },
		typeStyle = {},
		transparent = false,
		dimInactive = true,
		terminalColors = true,
		colors = {
			palette = {},
			theme = {
				wave = {},
				lotus = {},
				dragon = {},
				all = {
					ui = {
						bg_gutter = "none",
					},
				},
			},
		},
		overrides = overrides,
	})
	vim.cmd.colorscheme("kanagawa-wave")
end

return {
	"rebelot/kanagawa.nvim",
	config = config,
	lazy = false,
	priority = 1000,
	build = "KanagawaCompile",
}
