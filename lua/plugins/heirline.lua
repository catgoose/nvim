local config = function()
	local heirline = require("heirline")
	local conditions = require("heirline.conditions")
	local u = require("heirline.utils")
	local kanagawa = require("kanagawa.colors").setup({ theme = "wave" })
	local colors = kanagawa.palette
	heirline.load_colors(colors)
	local fn, api, bo = vim.fn, vim.api, vim.bo

	local status_inactive = {
		buftype = {
			"dashboard",
			"quickfix",
			"locationlist",
			"quickfix",
			"scratch",
			"prompt",
			"nofile",
		},
		filetype = {
			"dashboard",
			"harpoon",
			"startuptime",
			"mason.nvim",
			"terminal",
			"gypsy",
		},
	}
	local winbar_inactive = {
		buftype = { "nofile", "prompt", "quickfix", "terminal" },
		filetype = { "toggleterm", "qf", "terminal", "gypsy" },
	}
	local cmdtype_inactive = {
		":",
		"/",
		"?",
	}

	local recording_background_color = colors.autumnYellow
	local active_background_color = colors.sumiInk3
	local active_foreground_color = colors.sumiInk5
	local inactive_background_color = colors.sumiInk1
	local scrollbar_foreground_color = colors.dragonBlue
	local scrollbar_background_color = active_background_color

	local scrollbar_enabled = function()
		return api.nvim_buf_line_count(0) > 99 and conditions.is_active()
	end

	local Align = { provider = "%=" }
	local Space = { provider = " " }
	local LeftSep = { provider = "" }
	local RightSep = { provider = "" }

	local ActiveWindow = {
		hl = function()
			if conditions.is_active() then
				return { bg = active_background_color }
			else
				return { bg = inactive_background_color }
			end
		end,
	}

	local ActiveBlock = {
		hl = function()
			if conditions.is_active() then
				return { bg = active_foreground_color }
			else
				return { bg = active_foreground_color }
			end
		end,
	}

	local ActiveSep = {
		hl = function()
			if conditions.is_active() then
				return { fg = active_background_color }
			else
				return { fg = inactive_background_color }
			end
		end,
	}

	local FileIcon = {
		init = function(self)
			local filename = self.filename
			local extension = fn.fnamemodify(filename, ":e")
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
			local filename = fn.fnamemodify(self.filename, ":t")
			if filename == "" then
				return ""
			end
			if not conditions.width_percent_below(#filename, 0.1) then
				filename = fn.pathshorten(filename)
			end
			return filename
		end,
		hl = { fg = colors.oldWhite, bold = true },
	}

	local FileFlags = {
		{
			provider = function()
				if bo.modified then
					return "[+] "
				end
			end,
			hl = { fg = colors.oldWhite, bold = true, italic = true },
		},
		{
			provider = function()
				if not bo.modifiable or bo.readonly then
					return " "
				end
			end,
			hl = { fg = colors.roninYellow, bold = true, italic = true },
		},
	}

	local FileNameModifer = {
		hl = function()
			if bo.modified then
				return { italic = true, force = true }
			end
		end,
	}

	local diagnostics_spacer = " "
	local Diagnostics = {
		condition = conditions.has_diagnostics,
		static = {
			error_icon = fn.sign_getdefined("DiagnosticSignError")[1].text,
			warn_icon = fn.sign_getdefined("DiagnosticSignWarn")[1].text,
			info_icon = fn.sign_getdefined("DiagnosticSignInfo")[1].text,
			hint_icon = fn.sign_getdefined("DiagnosticSignHint")[1].text,
		},
		init = function(self)
			self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
			self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
			self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
			self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
		end,
		update = { "DiagnosticChanged", "BufEnter", "WinEnter" },
		{
			RightSep,
			hl = function()
				if conditions.is_active() then
					return {
						fg = active_foreground_color,
						bg = active_background_color,
					}
				else
					return {
						fg = active_foreground_color,
						bg = inactive_background_color,
					}
				end
			end,
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
		{
			condition = function()
				return not scrollbar_enabled()
			end,
			{
				Space,
			},
		},
		hl = { bg = active_foreground_color },
	}

	local Git = {
		condition = conditions.is_git_repo,
		init = function(self)
			self.status_dict = vim.b.gitsigns_status_dict
			self.has_changes = self.status_dict.added ~= 0
				or self.status_dict.removed ~= 0
				or self.status_dict.changed ~= 0
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
				hl = function()
					if conditions.is_active() then
						return {
							bg = active_background_color,
							fg = active_foreground_color,
						}
					else
						return {
							fg = active_foreground_color,
							bg = inactive_background_color,
						}
					end
				end,
			},
			hl = { bg = active_foreground_color },
		},
	}

	local MacroRecording = {
		condition = conditions.is_active,
		init = function(self)
			self.reg_recording = fn.reg_recording()
			self.status_dict = vim.b.gitsigns_status_dict or { added = 0, removed = 0, changed = 0 }
			self.has_changes = self.status_dict.added ~= 0
				or self.status_dict.removed ~= 0
				or self.status_dict.changed ~= 0
		end,
		{
			condition = function(self)
				return self.reg_recording ~= ""
			end,
			{
				condition = function(self)
					return self.has_changes
				end,
				LeftSep,
			},
			{
				provider = "   ",
				hl = { fg = colors.autumnRed },
			},
			{
				provider = function(self)
					return "@" .. self.reg_recording
				end,
				hl = { italic = false, bold = true },
			},
			{
				Space,
			},
			{
				LeftSep,
				hl = { bg = active_background_color, fg = recording_background_color },
			},
			hl = { bg = recording_background_color, fg = active_background_color },
		},
		update = { "RecordingEnter", "RecordingLeave" },
	}

	local FileType = {
		condition = function()
			return conditions.buffer_matches({ filetype = { "coderunner" } })
		end,
		provider = function()
			return bo.filetype
		end,
		hl = { fg = colors.oldWhite, bold = true },
	}

	local ScrollBar = {
		condition = function()
			return scrollbar_enabled()
		end,
		static = {
			sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
		},
		{
			{
				provider = function(self)
					local curr_line = api.nvim_win_get_cursor(0)[1]
					local lines = api.nvim_buf_line_count(0)
					local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
					return string.rep(self.sbar[i], 2)
				end,
				hl = function()
					return { fg = scrollbar_foreground_color, bg = scrollbar_background_color }
				end,
			},
		},
	}

	local FileNameBlock = {
		init = function(self)
			self.filename = api.nvim_buf_get_name(0)
		end,
	}
	local DiagnosticsBlock, GitBlock, MacroRecordingBlock, ScrollBarBlock = {}, {}, {}, {}

	FileNameBlock = u.insert(
		FileNameBlock,
		FileType,
		u.insert(ActiveSep, LeftSep),
		Space,
		unpack(FileFlags),
		u.insert(FileNameModifer, FileName, Space, FileIcon),
		{ provider = "%<" }
	)
	DiagnosticsBlock = u.insert(DiagnosticsBlock, Diagnostics)
	GitBlock = u.insert(GitBlock, Git)
	MacroRecordingBlock = u.insert(MacroRecordingBlock, MacroRecording)
	ScrollBarBlock = u.insert(ScrollBarBlock, ScrollBar)

	InactiveStatusline = {
		condition = function()
			conditions.buffer_matches(status_inactive)
		end,
		provider = function()
			return "%="
		end,
		hl = function()
			if conditions.is_active() then
				return { bg = active_background_color }
			else
				return { bg = inactive_background_color }
			end
		end,
	}

	ActiveStatusline = {
		condition = function()
			return not conditions.buffer_matches(status_inactive)
		end,
		GitBlock,
		MacroRecording,
		Align,
		DiagnosticsBlock,
		ScrollBarBlock,
		hl = function()
			if conditions.is_active() then
				return { bg = active_background_color }
			else
				return { bg = inactive_background_color }
			end
		end,
	}

	local StatusLines = {
		condition = function()
			for _, c in ipairs(cmdtype_inactive) do
				if vim.fn.getcmdtype() == c then
					return false
				end
			end
			return true
		end,
		InactiveStatusline,
		ActiveStatusline,
	}

	ActiveWinbar = {
		condition = function()
			local empty_buffer = function()
				return bo.ft == "" and bo.buftype == ""
			end
			return not conditions.buffer_matches(winbar_inactive) and not empty_buffer()
		end,
		Align,
		u.insert(ActiveBlock, FileNameBlock),
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
		u.insert(ActiveWindow, HiddenWinbar),
		u.insert(ActiveWindow, ActiveWinbar),
	}

	heirline.setup({
		statusline = StatusLines,
		winbar = WinBars,
	})
	vim.opt.winbar = "%{%v:lua.require'heirline'.eval_winbar()%}"
end

return {
	"rebelot/heirline.nvim",
	config = config,
	event = "BufReadPre",
	dependencies = "nvim-tree/nvim-web-devicons",
}
