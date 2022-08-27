local fn, cmd, api, o, g = vim.fn, vim.cmd, vim.api, vim.o, vim.g
local set_cur = api.nvim_win_set_cursor
local get_cur = api.nvim_win_get_cursor
local get_win = api.nvim_get_current_win
local utils = require("config.utils")
local set_g, get_g = utils.set_global, utils.get_global

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

local rename_current_file_extension = function(extension)
	local cur_name = api.nvim_buf_get_name(0)
	local tbl_file = vim.split(cur_name, ".", true)
	if tbl_file[#tbl_file - 1] .. "." .. tbl_file[#tbl_file] == "spec.ts" then
		tbl_file[#tbl_file - 1] = nil
	end
	tbl_file[#tbl_file] = nil
	for i, n in ipairs(tbl_file) do
		tbl_file[i] = n .. "."
	end
	tbl_file[#tbl_file + 1] = extension
	local str_file = table.concat(tbl_file, "")
	if fn.filereadable(str_file) ~= 1 then
		return false
	end
	return table.concat(tbl_file)
end

M.AngularEditFile = function(config)
	if not config.split then
		config.split = false
	end
	if not config.direction or not (config.direction == "right" or config.direction == "down") then
		config.direction = "right"
	end
	local ang_file = rename_current_file_extension(config.extension)
	if not ang_file then
		return false
	end
	if config.split == true then
		if config.direction == "right" then
			cmd.FocusSplitRight()
		elseif config.direction == "down" then
			cmd.FocusSplitDown()
		end
	end
	cmd.edit(ang_file)
end

local files_in_cwd = function()
	local path_file = fn.expand("%:p%:t")
	local path = vim.split(path_file, "/", true)
	path[#path] = nil
	path = table.concat(path, "/")

	local files_tbl = {}
	for _, file in ipairs(vim.split(fn.glob(path .. "/*"), "\n", true)) do
		if fn.filereadable(file) == 1 then
			files_tbl[#files_tbl + 1] = file
		end
	end

	return files_tbl
end

local find_tbl_index = function(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
	return nil
end

M.EditFileInCwd = function(cfg)
	if not cfg.order or not (cfg.order == "next" or cfg.order == "prev") then
		cfg.order = "next"
	end
	local direction = cfg.order == "next" and 1 or -1
	local path_file = fn.expand("%:p%:t")
	local files_tbl = files_in_cwd()
	local cur_file_index = find_tbl_index(files_tbl, path_file)
	if #files_tbl <= 1 then
		return false
	end
	if cur_file_index == #files_tbl and cfg.order == "next" then
		cmd.edit(files_tbl[1])
		return true
	end
	if cur_file_index == 1 and cfg.order == "prev" then
		cmd.edit(files_tbl[#files_tbl])
		return true
	end
	cmd.edit(files_tbl[cur_file_index + direction])
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

M.CommentYankPaste = function()
	local win = get_win()
	local cur = get_cur(win)
	local vstart = vim.fn.getpos("v")[2]
	local current_line = vim.fn.line(".")
	if vstart == current_line then
		cmd.yank()
		require("Comment.api").toggle.linewise.current()
		cmd.put()
		set_cur(win, { cur[1] + 1, cur[2] })
	else
		if vstart < current_line then
			cmd(":" .. vstart .. "," .. current_line .. "y")
			cmd.put()
			set_cur(win, { vim.fn.line("."), cur[2] })
		else
			cmd(":" .. current_line .. "," .. vstart .. "y")
			set_cur(win, { vstart, cur[2] })
			cmd.put()
			set_cur(win, { vim.fn.line("."), cur[2] })
		end
		require("Comment.api").toggle.linewise(vim.fn.visualmode())
	end
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

local toggle_toggleterm = function(opts)
	local Terminal = require("toggleterm.terminal").Terminal
	local term = Terminal:new(opts)
	term:toggle()
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
		winbar = {
			enabled = false,
		},
		shade_terminals = false,
		on_open = function(term)
			cmd.startinsert()
			api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
		end,
		on_close = function() end,
	}
	if not added_opts then
		return toggleterm_opts
	end
	return vim.tbl_deep_extend("force", toggleterm_opts, added_opts)
end

M.ToggleTermLazyGit = function(count)
	local opts = M.ToggleTermOpts({
		cmd = "lazygit",
		count = count,
	})
	toggle_toggleterm(opts)
end

M.ToggleTermBtm = function(count)
	local opts = M.ToggleTermOpts({
		cmd = "btm",
		count = count,
	})
	toggle_toggleterm(opts)
end

M.ToggleTermTerminal = function(count)
	local opts = M.ToggleTermOpts({
		count = count,
	})
	toggle_toggleterm(opts)
end

M.EditPreviousBuffer = function()
	if #fn.expand("#") > 0 then
		cmd.edit(vim.fn.expand("#"))
	end
end

return M
