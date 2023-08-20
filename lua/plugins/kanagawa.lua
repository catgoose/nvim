-- local get_color = function(name)
-- 	local color = vim.api.nvim_get_color_by_name(name)
-- 	if color == -1 then
-- 		color = vim.opt.background:get() == "dark" and 000 or 255255255
-- 	end
-- 	local byte = function(value, offset)
-- 		return bit.band(bit.rshift(value, offset), 0xFF)
-- 	end
-- 	return { byte(color, 16), byte(color, 8), byte(color, 0) }
-- end

-- local blend = function(fg, bg, alpha)
-- 	local bg_color = get_color(bg)
-- 	local fg_color = get_color(fg)
-- 	local channel = function(i)
-- 		local ret = (alpha * fg_color[i] + ((1 - alpha) * bg_color[i]))
-- 		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
-- 	end
-- 	return string.format("#%02X%02X%02X", channel(1), channel(2), channel(3))
-- end

local overrides = function(colors)
	local p = colors.palette
	-- local t = colors.theme
	return {
		CursorLine = {
			bold = true,
			italic = true,
			bg = p.sumiInk5,
		},
		Visual = {
			bold = true,
		},
		TreesitterContextBottom = {
			link = "Visual",
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
		Folded = {
			bg = p.sumiInk3,
		},
		StatusColumnFoldClosed = {
			fg = p.springViolet1,
			bold = false,
		},
		DashboardHeader = {
			fg = p.peachRed,
			bg = p.sumiInk3,
		},
		DashboardIcon = {
			fg = p.springBlue,
			bg = p.sumiInk3,
		},
		DashboardDesc = {
			fg = p.fujiWhite,
			bg = p.sumiInk3,
			italic = true,
		},
		DashboardKey = {
			fg = p.lightBlue,
			bg = p.sumiInk3,
			bold = true,
		},
		Pmenu = {
			fg = p.fujiWhite,
			bg = p.waveBlue1,
		},
		PmenuSel = {
			fg = p.waveBlue1,
			bg = p.springViolet2,
			bold = true,
		},
		UfoFoldedBg = {
			bg = p.waveBlue1,
			bold = true,
		},
	}
end

local config = function()
	require("kanagawa").setup({
		compile = false,
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
}
