local fn = vim.fn
local bo = vim.bo
local cmd = vim.cmd
local api = vim.api
local o = vim.o
local g = vim.g
local set_cur = api.nvim_win_set_cursor
local get_cur = api.nvim_win_get_cursor
local get_win = api.nvim_get_current_win
local set_win = api.nvim_set_current_win
local utils = require("config.utils")
local set_g = utils.set_global
local get_g = utils.get_global

local M = {}

M.ToggleZenMode = function()
	if get_g("zen_full_screen_status") == 0 then
		set_g("zen_full_screen_status", 1)
		fn.system("i3 bar mode hide bar-1")
		fn.system("i3 fullscreen enable")
		fn.system("tmux set status off")
		o.cmdheight = 0
	else
		set_g("zen_full_screen_status", 0)
		fn.system("tmux set status on")
		fn.system("i3 bar mode dock bar-1")
		fn.system("i3 fullscreen disable")
		M.RestoreCmdHeight()
	end
end

M.OpenSplitAngularTemplateUrl = function()
	local win = get_win()
	local cur = get_cur(win)

	if bo.filetype == "typescript" and fn.search("angular") and fn.search("templateUrl") then
		local pos = fn.searchpos("html")
		if pos[1] > 0 and pos[2] > 0 then
			cmd.FocusSplitDown()
			local html_win = get_win()
			if bo.filetype == "typescript" then
				fn.execute("normal gf")
			end
			set_win(win)
			set_cur(win, cur)
			set_win(html_win)
			set_cur(html_win, { 1, 0 })
		end
	else
		set_cur(win, cur)
	end
end

M.OpenAngularTemplateUrl = function()
	local win = get_win()
	local cur = get_cur(win)

	if bo.filetype == "typescript" and fn.search("angular") and fn.search("templateUrl") then
		local pos = fn.searchpos("html")
		if pos[1] > 0 and pos[2] > 0 then
			if bo.filetype == "typescript" then
				fn.execute("normal gf")
				cmd.edit("#")
				set_cur(win, cur)
				cmd.edit("#")
			end
		end
	else
		set_cur(win, cur)
	end
end

local TypeScriptSpecFile = function()
	if not bo.filetype == "typescript" then
		return false
	end
	local spec_file = fn.split(api.nvim_buf_get_name(0), ".ts")[1] .. ".spec.ts"
	if fn.filereadable(spec_file) ~= 1 then
		return false
	end
	return spec_file
end

M.OpenTypescriptSpecFileSplit = function()
	local spec_file = TypeScriptSpecFile()
	if spec_file then
		cmd.FocusSplitRight()
		cmd.edit(spec_file)
		set_cur(0, { 1, 0 })
	end
end

M.OpenTypescriptSpecFile = function()
	local spec_file = TypeScriptSpecFile()
	if spec_file then
		cmd.edit(spec_file)
		set_cur(0, { 1, 0 })
	end
end

M.CommentYankPaste = function()
	local win = get_win()
	local cur = get_cur(win)
	cmd.yank()
	require("Comment.api").toggle_linewise_op("")
	cmd.put()
	set_cur(win, { cur[1] + 1, cur[2] })
end

M.ToggleTermOpts = function(added_opts)
	local toggleterm_opts = {
		direction = "float",
		float_opts = {
			border = "curved",
			width = 145,
			height = 35,
			winblend = 8,
		},
	}
	if not added_opts then
		return toggleterm_opts
	end
	return vim.tbl_deep_extend("force", toggleterm_opts, added_opts)
end

local toggle_toggleterm = function(opts)
	local Terminal = require("toggleterm.terminal").Terminal
	local term = Terminal:new(opts)
	term:toggle()
end

M.ToggleTermLazyGit = function(count)
	local opts = M.ToggleTermOpts({
		cmd = "lazygit",
		count = count,
		on_open = function(term)
			cmd.startinsert()
			api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
		end,
	})
	toggle_toggleterm(opts)
end

M.ToggleTermBtm = function(count)
	local opts = M.ToggleTermOpts({
		cmd = "btm",
		count = count,
		on_open = function(term)
			cmd.startinsert()
			api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
		end,
	})
	toggle_toggleterm(opts)
end

M.ToggleTermTerminal = function(count)
	local opts = M.ToggleTermOpts({
		count = count,
	})
	toggle_toggleterm(opts)
end

M.EqualizeToggleFocus = function()
	cmd.FocusEqualise()
	cmd.FocusToggle()
end

M.BufOnlyWindowOnly = function()
	if #api.nvim_list_wins() > 1 then
		cmd.only()
	end
	cmd.BufOnly()
end

M.ToggleCmdHeight = function()
	if o.cmdheight == 1 then
		o.cmdheight = 0
		g.CMDHEIGHTZERO = 1
	else
		o.cmdheight = 1
		g.CMDHEIGHTZERO = 0
	end
end

M.RestoreCmdHeight = function()
	if g.CMDHEIGHTZERO == 1 then
		o.cmdheight = 0
	else
		o.cmdheight = 1
	end
end

M.TypeScriptFixAll = function()
	local typescript = require("typescript")
	local sync = { sync = true }
	if #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) > 0 then
		typescript.actions.addMissingImports(sync)
	end
	if #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) > 0 then
		typescript.actions.removeUnused(sync)
	end
	if #vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.INFO } }) == 0 then
		typescript.actions.organizeImports(sync)
	end
end

M.ReloadConfigs = function()
	for _, file in ipairs(vim.api.nvim_get_runtime_file("lua/config/*.lua", true)) do
		vim.cmd.luafile(file)
	end
end

M.ReloadSnippets = function()
	for _, file in ipairs(vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)) do
		vim.cmd.luafile(file)
	end
end

return M
