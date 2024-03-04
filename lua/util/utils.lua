local fn, api, cmd, diag, o, g, tbl_contains, bo, keymap =
	vim.fn, vim.api, vim.cmd, vim.diagnostic, vim.o, vim.g, vim.tbl_contains, vim.bo, vim.keymap

local M = {}

M.cmd_map = function(lhs, rhs, modes, opts)
	modes = M.str_to_tbl(modes) or { "n" }
	opts = opts or { silent = true, noremap = true }
	for _, mode in ipairs(modes) do
		keymap.set(mode, lhs, M.cmd_string(rhs), opts)
	end
end

M.key_map = function(lhs, rhs, modes, opts)
	modes = M.str_to_tbl(modes) or { "n" }
	opts = opts or { silent = true, noremap = true }
	for _, mode in ipairs(modes) do
		keymap.set(mode, lhs, rhs, opts)
	end
end

M.cmd_string = function(cmd_arg)
	return [[<cmd>]] .. cmd_arg .. [[<cr>]]
end

M.lazy_map = function(lhs, rhs, modes)
	if type(rhs) == "string" then
		rhs = M.cmd_string(rhs)
	end
	modes = M.str_to_tbl(modes) or { "n" }
	return {
		lhs,
		rhs,
		mode = modes,
	}
end

M.create_augroup = function(group, opts)
	opts = opts or { clear = true }
	return api.nvim_create_augroup(group, opts)
end

M.nonrelative_win_count = function()
	local wins = api.nvim_list_wins()
	local non_relative = 0
	for _, win in ipairs(wins) do
		local config = api.nvim_win_get_config(win)
		---@diagnostic disable-next-line: undefined-field
		if config.relative == "" then
			non_relative = non_relative + 1
		end
	end
	return non_relative
end

M.current_word = function()
	local current_word = fn.expand("<cword>")
	return current_word
end

M.str_to_tbl = function(v)
	if type(v) == "string" then
		v = { v }
	end
	return v
end

M.tbl_index = function(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
	return nil
end

M.tbl_foreach = function(tbl, f)
	local t = {}
	for key, value in ipairs(tbl) do
		t[key] = f(value)
	end
	return t
end

M.tbl_filter = function(tbl, f)
	if not tbl or tbl == {} then
		return {}
	end
	local t = {}
	for key, value in ipairs(tbl) do
		if f(key, value) then
			table.insert(t, value)
		end
	end
	return t
end

M.list_concat = function(A, B)
	local t = {}
	for _, value in ipairs(A) do
		table.insert(t, value)
	end
	for _, value in ipairs(B) do
		table.insert(t, value)
	end
	return t
end

M.tbl_system_cmd = function(command)
	local stdout = {}
	local handle = io.popen(command .. " 2>&1 ; echo $?", "r")
	if handle then
		for line in handle:lines() do
			stdout[#stdout + 1] = line
		end
		stdout[#stdout] = nil
		handle:close()
	end
	return stdout
end

M.map_q_to_quit = function(event)
	bo[event.buf].buflisted = false
	M.cmd_map("q", "close", "n", { silent = true, noremap = true, buffer = true })
end

M.is_qf_empty = function()
	return vim.tbl_isempty(fn.getqflist())
end

local is_lsp_diag_error = function()
	return #diag.get(0, { severity = diag.severity.ERROR }) > 0
end
local is_lsp_diag_warning = function()
	return #diag.get(0, { severity = diag.severity.WARN }) > 0
end
local is_lsp_diag_info = function()
	return #diag.get(0, { severity = diag.severity.INFO }) > 0
end

M.lsp_diag = function(level)
	if level == "error" then
		return is_lsp_diag_error()
	elseif level == "warning" then
		return is_lsp_diag_warning()
	elseif level == "info" then
		return is_lsp_diag_info()
	end
end

M.restore_cmdheight = function()
	if g.CMDHEIGHTZERO == 1 then
		o.cmdheight = 0
	else
		o.cmdheight = 1
	end
end

M.create_cmd = function(command, f, opts)
	opts = opts or {}
	api.nvim_create_user_command(command, f, opts)
end

M.screen_scale = function(config)
	local defaults = {
		width = 0.5,
		height = 0.5,
	}
	config = config or defaults
	config.width = config.width or defaults.width
	config.height = config.height or defaults.height
	local width = fn.round(o.columns * config.width)
	local height = fn.round(o.lines * config.height)
	return { width = width, height = height }
end

M.load_configs = function()
	for _, file in ipairs(M.get_config_modules()) do
		require("config." .. file)
	end
	require("config.lazy")
end

M.get_config_modules = function(exclude_map)
	exclude_map = exclude_map or {
		"lazy",
		"init",
		"statuscol",
	}
	local files = {}
	for _, file in ipairs(fn.glob(fn.stdpath("config") .. "/lua/config/*.lua", true, true)) do
		table.insert(files, fn.fnamemodify(file, ":t:r"))
	end
	files = vim.tbl_filter(function(file)
		for _, pattern in ipairs(exclude_map) do
			if file:match(pattern) then
				return false
			end
		end
		return true
	end, files)
	return files
end

M.reload_lua = function()
	for _, file in ipairs(M.get_config_modules()) do
		R("config." .. file)
		R("util.functions")
	end
	cmd.nohlsearch()
end

M.diag_error = function()
	return #diag.get(0, { severity = diag.severity.ERROR }) ~= 0
end

M.treesitter_is_css_class_under_cursor = function()
	local ft = bo.filetype
	if not tbl_contains({ "typescript", "typescriptreact", "vue", "html", "svelt", "astro" }, ft) then
		return false
	end
	local ft_query = [[
    (attribute
      (attribute_name) @attr_name
        (quoted_attribute_value (attribute_value) @attr_val)
        (#match? @attr_name "class")
    )
    ]]
	local queries = vim.treesitter.query.parse(ft, ft_query)
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.treesitter.get_node({
		bufnr = bufnr,
		ignore_injections = false,
	})
	if cursor == nil then
		return false
	end
	local parent = cursor:parent()

	if not parent then
		return false
	end

	if queries == nil then
		return false
	end

	for id, _ in queries:iter_captures(parent, bufnr, 0, -1) do
		local name = queries.captures[id]
		return #name > 0
	end
end

local is_diag_for_cur_pos = function()
	local diagnostics = vim.diagnostic.get(0)
	local pos = api.nvim_win_get_cursor(0)
	if #diagnostics == 0 then
		return false
	end
	local message = vim.tbl_filter(function(d)
		return d.col == pos[2] and d.lnum == pos[1] - 1
	end, diagnostics)
	return #message > 0
end

M.hover_handler = function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if winid then
		return
	end
	local ft = bo.filetype
	if tbl_contains({ "vim", "help" }, ft) then
		cmd("silent! h " .. fn.expand("<cword>"))
	-- elseif M.treesitter_is_css_class_under_cursor() then
	-- 	cmd("TWValues")
	elseif tbl_contains({ "man" }, ft) then
		cmd("silent! Man " .. fn.expand("<cword>"))
	elseif is_diag_for_cur_pos() then
		vim.diagnostic.open_float()
	else
		vim.lsp.buf.hover()
	end
end

M.is_x_display = function()
	local x_display = os.getenv("DISPLAY")
	return x_display ~= nil and x_display ~= ""
end

M.is_keymap_set = function(mode, lhs)
	local km = api.nvim_get_keymap(mode)
	for _, map in ipairs(km) do
		if map.lhs == lhs then
			return true
		end
	end
	return false
end

return M
