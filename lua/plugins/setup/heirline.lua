--  TODO: 2022-08-16 - when opening terminal, don't hide statusbar
local heirline = require("heirline")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local colors = require("kanagawa.colors").setup()
heirline.load_colors(colors)
local display_winbar = require("config.utils").display_winbar

local Align = { provider = "%=" }
local Space = { provider = " " }
local LeftSep = { provider = "" }
local RightSep = { provider = "" }

local ActiveWindow = {
	hl = function()
		if conditions.is_active() then
			return { bg = colors.sumiInk1 }
		else
			return { bg = colors.sumiInk1b }
		end
	end,
}

local ActiveBlock = {
	hl = function()
		if conditions.is_active() then
			return { bg = colors.sumiInk3 }
		else
			return { bg = colors.sumiInk3 }
		end
	end,
}

local ActiveSep = {
	hl = function()
		if conditions.is_active() then
			return { fg = colors.sumiInk1 }
		else
			return { fg = colors.sumiInk1b }
		end
	end,
}

local status_inactive = {
	buftype = {
		"quickfix",
		"locationlist",
		-- "terminal",
		"quickfix",
		"scratch",
		"prompt",
		"packer",
		"nofile",
	},
	filetype = { "alpha", "harpoon", "startuptime", "packer", "mason.nvim" },
}

local winbar_inactive = {
	buftype = { "nofile", "prompt", "quickfix", "terminal" },
	filetype = { "toggleterm", "qf" },
}

local FileNameBlock = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
}

local DiagnosticsBlock, GitBlock = {}, {}

local FileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color =
			require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		if self.filename == "" then
			return ""
		else
			return self.icon and (self.icon .. " ")
		end
	end,
	hl = function(self)
		return { fg = self.icon_color }
	end,
}

local FileName = {
	provider = function(self)
		local filename = vim.fn.fnamemodify(self.filename, ":t")
		if filename == "" then
			return ""
		end
		if not conditions.width_percent_below(#filename, 0.1) then
			filename = vim.fn.pathshorten(filename)
		end
		return filename
	end,
	hl = { fg = colors.oldWhite, bold = true },
}

local FileFlags = {
	{
		provider = function()
			if vim.bo.modified then
				return "[+] "
			end
		end,
		hl = { fg = colors.oldWhite, bold = true, italic = true },
	},
	{
		provider = function()
			if not vim.bo.modifiable or vim.bo.readonly then
				return " "
			end
		end,
		hl = { fg = colors.roninYellow, bold = true, italic = true },
	},
}

local FileNameModifer = {
	hl = function()
		if vim.bo.modified then
			return { italic = true, force = true }
		end
	end,
}

local diagnostics_spacer = " "
local Diagnostics = {
	condition = conditions.has_diagnostics,
	static = {
		error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
		warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
		info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
		hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
	},
	init = function(self)
		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
	end,
	update = { "DiagnosticChanged", "BufEnter" },
	{
		RightSep,
		hl = { fg = colors.sumiInk3, bg = colors.sumiInk1 },
	},
	Space,
	{
		provider = function(self)
			return self.errors > 0 and (self.error_icon .. self.errors .. diagnostics_spacer) or ""
		end,
		hl = { fg = colors.samuraiRed },
	},
	{
		provider = function(self)
			return self.warnings > 0 and (self.warn_icon .. self.warnings .. diagnostics_spacer)
		end,
		hl = { fg = colors.roninYellow },
	},
	{
		provider = function(self)
			return self.info > 0 and (self.info_icon .. self.info .. diagnostics_spacer)
		end,
		hl = { fg = colors.waveAqua1 },
	},
	{
		provider = function(self)
			return self.hints > 0 and (self.hint_icon .. self.hints .. diagnostics_spacer)
		end,
		hl = { fg = colors.dragonBlue },
	},
	Space,
	hl = { bg = colors.sumiInk3 },
}

local Git = {
	condition = conditions.is_git_repo,
	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,
	{
		condition = function(self)
			return self.has_changes
		end,
		{
			provider = function(self)
				return "  " .. self.status_dict.head .. " "
			end,
			hl = { fg = colors.springViolet1, bold = true, italic = true },
		},
		{
			provider = function(self)
				local count = self.status_dict.added or 0
				return count > 0 and ("+" .. count .. " ")
			end,
			hl = { fg = colors.autumnGreen, bold = true },
		},
		{
			provider = function(self)
				local count = self.status_dict.removed or 0
				return count > 0 and ("-" .. count .. " ")
			end,
			hl = { fg = colors.autumnRed, bold = true },
		},
		{
			provider = function(self)
				local count = self.status_dict.changed or 0
				return count > 0 and ("~" .. count .. " ")
			end,
			hl = { fg = colors.autumnYellow, bold = true },
		},
		{
			LeftSep,
			hl = { fg = colors.sumiInk3, bg = colors.sumiInk1 },
		},
		hl = { bg = colors.sumiInk3 },
	},
}

FileNameBlock = utils.insert(
	FileNameBlock,
	utils.insert(ActiveSep, LeftSep),
	Space,
	unpack(FileFlags),
	utils.insert(FileNameModifer, FileName, Space, FileIcon),
	{ provider = "%<" }
)

DiagnosticsBlock = utils.insert(DiagnosticsBlock, Diagnostics)
GitBlock = utils.insert(GitBlock, Git)

InactiveStatusline = {
	condition = function()
		return conditions.buffer_matches(status_inactive)
	end,
	provider = function()
		return "%="
	end,
	hl = { bg = colors.sumiInk1 },
}

ActiveStatusline = {
	condition = function()
		return not conditions.buffer_matches(status_inactive)
	end,
	GitBlock,
	Align,
	DiagnosticsBlock,
	hl = { bg = colors.sumiInk1 },
}

local StatusLines = {
	InactiveStatusline,
	ActiveStatusline,
}

ActiveWinbar = {
	condition = function()
		return not conditions.buffer_matches(winbar_inactive) and display_winbar()
	end,
	Align,
	utils.insert(ActiveBlock, FileNameBlock),
}

HiddenWinbar = {
	condition = function()
		return conditions.buffer_matches(winbar_inactive)
	end,
	init = function()
		vim.opt_local.winbar = nil
	end,
}
local WinBars = {
	utils.insert(ActiveWindow, HiddenWinbar),
	utils.insert(ActiveWindow, ActiveWinbar),
}

-- heirline.setup(StatusLines, WinBars)
heirline.setup(StatusLines)
heirline.winbar = require("heirline.statusline"):new(WinBars)
vim.opt.winbar = "%{%v:lua.require'heirline'.eval_winbar()%}"
