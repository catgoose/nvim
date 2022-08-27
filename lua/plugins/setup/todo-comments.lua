--  HACK: 2022-08-16 - fixes error when accessing nofile bufer.  use codeblock until PR is merged: https://github.com/folke/todo-comments.nvim/issues/97#issuecomment-1129990423
local hl = require("todo-comments.highlight")
local highlight_win = hl.highlight_win
hl.highlight_win = function(win, force)
	pcall(highlight_win, win, force)
end

-- require("todo-comments").setup()
require("config.utils").plugin_setup("todo-comments", {
	signs = true,
	sign_priority = 10,
	keywords = {
		FIX = {
			icon = " ",
			color = "error",
			alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
		},
		TODO = { icon = " ", color = "info" },
		HACK = { icon = " ", color = "warning" },
		WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
		PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
		NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
		TEST = { icon = "", color = "warning" },
	},
	merge_keywords = true,
	highlight = {
		before = "",
		keyword = "wide",
		after = "fg",
		pattern = [[.*<(KEYWORDS)\s*:]],
		comments_only = true,
		max_line_len = 400,
		exclude = {},
	},
	colors = {
		error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
		warning = { "DiagnosticWarning", "WarningMsg", "#FBBF24" },
		info = { "DiagnosticInfo", "#2563EB" },
		hint = { "DiagnosticHint", "#10B981" },
		default = { "Identifier", "#7C3AED" },
	},
	search = {
		command = "rg",
		args = {
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
		},
		pattern = [[\b(KEYWORDS):]], -- ripgrep regex
	},
})
