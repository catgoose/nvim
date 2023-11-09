local fn, cmd, api, o, g, ui = vim.fn, vim.cmd, vim.api, vim.o, vim.g, vim.ui
local set_cur = api.nvim_win_set_cursor
local u = require("util")
local t = require("util.toggle")
local ufo = require("util.ufo")

local M = {}

M.comment_yank_paste = function()
	local win = api.nvim_get_current_win()
	local cur = api.nvim_win_get_cursor(win)
	local vstart = fn.getpos("v")[2]
	local current_line = fn.line(".")
	if vstart == current_line then
		cmd.yank()
		require("Comment.api").toggle.linewise.current()
		cmd.put()
		set_cur(win, { cur[1] + 1, cur[2] })
	else
		if vstart < current_line then
			cmd(":" .. vstart .. "," .. current_line .. "y")
			cmd.put()
			set_cur(win, { fn.line("."), cur[2] })
		else
			cmd(":" .. current_line .. "," .. vstart .. "y")
			set_cur(win, { vstart, cur[2] })
			cmd.put()
			set_cur(win, { fn.line("."), cur[2] })
		end
		require("Comment.api").toggle.linewise(fn.visualmode())
	end
end

M.buf_only = function()
	if #api.nvim_list_wins() > 1 then
		cmd.only()
	end
	cmd.BufOnly()
end

M.win_only = function(cb)
	cb = cb or nil
	if #api.nvim_list_wins() > 1 then
		cmd.only()
	end
	if cb then
		cb()
	end
end

M.toggle_cmdheight = function()
	if o.cmdheight == 1 then
		o.cmdheight = 0
		g.CMDHEIGHTZERO = 1
	else
		o.cmdheight = 1
		g.CMDHEIGHTZERO = 0
	end
end

-- line for git testing
M.toggle_term_cmd = function(config)
	if not config or not config.count then
		return
	end
	if config.cmd[1] ~= nil then
		ui.select(config.cmd, {
			prompt = "Select command",
		}, function(selected)
			if not selected then
				return
			end
			config.cmd = selected
			M.toggle_term_cmd(config)
		end)
	else
		local term_config = t.toggleterm_opts(config)
		local Terminal = require("toggleterm.terminal").Terminal
		local term = Terminal:new(term_config)
		term:toggle()
	end
end

M.run_system_command = function(config)
	if not config or not config.cmd then
		return
	end
	config.notify_config = config.notify_config or { title = "System Command" }
	vim.defer_fn(function()
		local handle = io.popen(config.cmd)
		if handle then
			local result = handle:read("*a")
			handle:close()
			if config.notify == true then
				require("notify").notify(result, vim.log.levels.INFO, config.notify_config)
			end
		end
	end, 0)
end

M.load_previous_buffer = function()
	if #fn.expand("#") > 0 then
		cmd.edit(fn.expand("#"))
	end
end

M.populate_qf = function(lines, mode)
	if mode == nil or type(mode) == "table" then
		lines = u.tbl_foreach(lines, function(item)
			return { filename = item, lnum = 1, col = 1, text = item }
		end)
		mode = "r"
	end
	fn.setqflist(lines, mode)
	cmd.cwindow()
	cmd([[wincmd p]])
end

local open_help_tab = function(help_cmd, topic)
	cmd.tabe()
	local winnr = api.nvim_get_current_win()
	cmd("silent! " .. help_cmd .. " " .. topic)
	api.nvim_win_close(winnr, false)
end

M.help_word = function()
	local current_word = u.current_word()
	open_help_tab("help", current_word)
end

M.tagstack_navigate = function(config)
	if not config or not config.direction then
		return
	end
	local direction = config.direction
	local tagstack = fn.gettagstack()
	if tagstack == nil or tagstack.items == nil or #tagstack.items == 0 then
		return
	end
	if direction == "up" then
		if tagstack.curidx > tagstack.length then
			return
		end
		cmd.tag()
	end
	if direction == "down" then
		if tagstack.curidx == 1 then
			return
		end
		cmd.pop()
	end
end

M.wilder_update_remote_plugins = function()
	local update = function()
		cmd([[silent! UpdateRemotePlugins]])
	end
	local rplugin = fn.stdpath("data") .. "/rplugin.vim"
	if fn.filereadable(rplugin) ~= 1 then
		update()
		return
	end
	local wilder_updated = false
	for _, line in ipairs(fn.readfile(rplugin)) do
		if line:match("wilder#lua#remote#host") then
			wilder_updated = true
			break
		end
	end
	if not wilder_updated then
		update()
		return
	end
end

M.spectre_open = function()
	cmd([[lua require("spectre").open()]])
end

M.spectre_open_word = function()
	cmd([[lua require("spectre").open_visual({select_word = true})]])
end

M.spectre_open_cwd = function()
	cmd([[lua require("spectre").open_file_search()]])
end

M.reload_dev = function()
	u.reload_dev()
end

M.reload_lua = function()
	u.reload_lua()
end

M.update_all = function()
	local cmds = {
		"MasonToolsUpdate",
		"TSUpdate",
		"Lazy sync",
	}
	for _, c in ipairs(cmds) do
		cmd(c)
		print("Running: " .. c)
	end
end

M.ufo_toggle_fold = function()
	return ufo.toggle_fold()
end

M.fold_paragraph = function()
	local foldclosed = fn.foldclosed(fn.line("."))
	if foldclosed == -1 then
		cmd([[silent! normal! zfip]])
	else
		cmd("silent! normal! zo")
	end
end

M.make_run = function()
	if M.terminal_send_cmd("") then
		local file_name = fn.expand("%:t:r")
		M.terminal_send_cmd("make " .. file_name)
		M.terminal_send_cmd("clear && ./" .. file_name)
	else
		cmd.make([[%<]])
		cmd([[!./%<]])
		cmd.cwindow()
	end
end

u.create_augroup("MakeOnSave")
M.auto_make_toggle = function()
	local autocmds = api.nvim_get_autocmds({ group = "MakeOnSave" })
	if #autocmds > 0 then
		u.create_augroup("MakeOnSave")
	else
		local make_on_save = u.create_augroup("MakeOnSave")
		api.nvim_create_autocmd({ "BufWritePost" }, {
			group = make_on_save,
			pattern = { "*.cpp" },
			callback = function()
				M.make_run()
			end,
		})
	end
end

M.terminal_send_cmd = function(cmd_text)
	local function get_first_terminal()
		local terminal_chans = {}
		for _, chan in pairs(api.nvim_list_chans()) do
			if chan["mode"] == "terminal" and chan["pty"] ~= "" then
				table.insert(terminal_chans, chan)
			end
		end
		table.sort(terminal_chans, function(left, right)
			return left["buffer"] < right["buffer"]
		end)
		if #terminal_chans == 0 then
			return nil
		end
		return terminal_chans[1]["id"]
	end

	local send_to_terminal = function(terminal_chan, term_cmd_text)
		api.nvim_chan_send(terminal_chan, term_cmd_text .. "\n")
	end

	local terminal = get_first_terminal()
	if not terminal then
		return nil
	end

	if not cmd_text then
		ui.input({ prompt = "Send to terminal: " }, function(input_cmd_text)
			if not input_cmd_text then
				return nil
			end
			send_to_terminal(terminal, input_cmd_text)
		end)
	else
		send_to_terminal(terminal, cmd_text)
	end
	return true
end

M.netrw = function()
	cmd.tabnew("%")
	cmd([[silent! Explore]])
end

return M
