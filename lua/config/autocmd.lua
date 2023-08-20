local u = require("util")
local api, fn, bo, opt_local, cmd = vim.api, vim.fn, vim.bo, vim.opt_local, vim.cmd
local augroup, q_to_quit = u.create_augroup, u.map_q_to_quit
local autocmd = api.nvim_create_autocmd
local file_pattern = {
	"*.css",
	"*.fish",
	"*.html",
	"*.json",
	"*.lua",
	"*.md",
	"*.rb",
	"*.sass",
	"*.scss",
	"*.sh",
	"*.ts",
	"Dockerfile",
	"docker-compose.yaml",
	"*.cpp",
}
-- Filetype
local buf_event = { "BufReadPre", "BufNewFile" }
local set_filetype = augroup("SetFileTypeOptLocalOptions")
autocmd(buf_event, {
	group = set_filetype,
	pattern = { "*.i3config" },
	callback = function()
		opt_local.filetype = "i3config"
	end,
})
autocmd(buf_event, {
	group = set_filetype,
	pattern = { "*.rasi" },
	callback = function()
		opt_local.filetype = "sass"
	end,
})
autocmd(buf_event, {
	group = set_filetype,
	pattern = { "*.md.gpg" },
	callback = function()
		opt_local.filetype = "markdown"
	end,
})
autocmd({ "FileType" }, {
	group = set_filetype,
	pattern = { "markdown" },
	callback = function()
		opt_local.colorcolumn = "80"
	end,
})

local all_filetypes = augroup("AllFileTypesLocalOptions")
autocmd({ "FileType" }, {
	group = all_filetypes,
	pattern = { "*" },
	callback = function()
		opt_local.formatoptions = opt_local.formatoptions - "t" + "c" - "r" - "o" - "q" - "a" + "n" - "2" + "l" + "j"
	end,
})
autocmd({ "FileType" }, {
	group = all_filetypes,
	pattern = { "*" },
	callback = function()
		u.restore_cmdheight()
	end,
})

local markdown = augroup("MarkdownWrap")
autocmd({ "FileType" }, {
	group = markdown,
	pattern = { "gitcommit", "markdown" },
	callback = function()
		opt_local.wrap = true
		opt_local.spell = true
	end,
})

local harpoon = augroup("HarpoonCursorLine")
autocmd({ "FileType" }, {
	group = harpoon,
	pattern = { "harpoon" },
	callback = function()
		opt_local.cursorline = true
		opt_local.numberwidth = 5
	end,
})

local quit = augroup("FtQToQuit")
autocmd({ "FileType" }, {
	group = quit,
	pattern = {
		"copilot.*",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"spectre_panel",
		"tsplayground",
		"octo",
		"ClangdAST",
		"ClangdTypeHierarchy",
		"dap-repl",
		"dapui_watches",
		"dapui_stacks",
		"dapui_breakpoints",
		"dapui_scopes",
		"dapui_console",
	},
	callback = function(event)
		q_to_quit(event)
	end,
})
autocmd({ "FileType" }, {
	group = quit,
	pattern = { "*" },
	callback = function(event)
		if bo.buftype == "nofile" then
			q_to_quit(event)
		end
	end,
})
autocmd({ "BufEnter" }, {
	group = quit,
	pattern = { "*" },
	callback = function(event)
		if bo.buftype == "" and bo.filetype == "" then
			q_to_quit(event)
		end
	end,
})

local terminal = augroup("TerminalLocalOptions")
autocmd({ "TermOpen" }, {
	group = terminal,
	pattern = { "*" },
	callback = function(event)
		opt_local.number = false
		opt_local.relativenumber = false
		opt_local.cursorline = false
		opt_local.signcolumn = "no"
		opt_local.statuscolumn = ""
		for _, key in ipairs({ "h", "j", "k", "l" }) do
			vim.keymap.set("t", "<C-" .. key .. ">", function()
				local code_term_esc = api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true)
				local code_dir = api.nvim_replace_termcodes("<C-" .. key .. ">", true, true, true)
				api.nvim_feedkeys(code_term_esc .. code_dir, "t", true)
			end, { noremap = true })
		end
		if bo.filetype == "" then
			api.nvim_buf_set_option(event.buf, "filetype", "terminal")
			cmd.startinsert()
		end
		local createExitAuGroup = function()
			return augroup("TerminalExited0" .. event.buf .. "-" .. event.id)
		end
		local terminalExit = createExitAuGroup()
		autocmd("TextChangedT", {
			group = terminalExit,
			callback = function()
				local buffer_table = api.nvim_buf_get_lines(0, 0, -1, false)
				local buffer_text = table.concat(buffer_table, "\n")
				if string.find(buffer_text, "Process exited 0") then
					api.nvim_input("<ESC>")
					createExitAuGroup()
				end
			end,
		})
	end,
})

local dashboard = augroup("DashboardWinhighlight")
autocmd({ "FileType" }, {
	group = dashboard,
	pattern = { "dashboard" },
	callback = function()
		vim.wo.winhighlight = "NormalNC:Normal"
		autocmd({ "BufReadPre" }, {
			group = dashboard,
			pattern = { "*" },
			callback = function()
				vim.wo.winhighlight = ""
				augroup("DashboardWinhighlight")
			end,
		})
	end,
})

-- Buffer
local buffer = augroup("BufferDetectChanges")
autocmd({ "FocusGained", "BufEnter" }, {
	group = buffer,
	pattern = file_pattern,
	callback = function()
		cmd.checktime()
	end,
})

local cursor_line = augroup("LocalCursorLine")
autocmd({ "WinEnter", "BufWinEnter" }, {
	group = cursor_line,
	pattern = file_pattern,
	callback = function()
		opt_local.cursorline = true
	end,
})
autocmd({ "WinLeave" }, {
	group = cursor_line,
	pattern = file_pattern,
	callback = function()
		opt_local.cursorline = false
	end,
})

-- Lua reload
local write_source = augroup("WritePostReload")
autocmd({ "BufWritePost" }, {
	group = write_source,
	pattern = {
		"*/nvim/lua/config/*.lua",
		"*/nvim/lua/util/*.lua",
	},
	callback = function()
		if not u.diag_error() then
			u.reload_lua()
		end
	end,
})
autocmd({ "BufWritePost" }, {
	group = write_source,
	pattern = "*/nvim/lua/snippets/*.lua",
	callback = function()
		if not u.diag_error() then
			require("luasnip.loaders.from_lua").load({ paths = fn.stdpath("config") .. "/lua/snippets" })
		end
	end,
})
