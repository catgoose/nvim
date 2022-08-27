local utils = require("config.utils")
local map_cmd, map, augroup = utils.map_cmd, utils.map, utils.create_augroup
local api = vim.api
local autocmd = api.nvim_create_autocmd
local opt_local = vim.opt_local
local cmd = vim.cmd
local file_pattern = {
	"*.ts",
	"*.html",
	"*.css",
	"*.scss",
	"*.sass",
	"*.json",
	"*.fish",
	"*.md",
	"*.sh",
	"*.lua",
}
-- Filetype
local set_filetype = augroup("SetFileTypes")
autocmd({ "BufReadPre", "BufNewFile" }, {
	group = set_filetype,
	pattern = { "*.i3config" },
	callback = function()
		opt_local.filetype = "i3config"
	end,
})
autocmd({ "BufReadPre", "BufNewFile" }, {
	group = set_filetype,
	pattern = { "*.rasi" },
	callback = function()
		opt_local.filetype = "sass"
	end,
})
autocmd({ "BufReadPre", "BufNewFile" }, {
	group = set_filetype,
	pattern = { "*.htmlhintrc" },
	callback = function()
		opt_local.filetype = "json"
	end,
})
autocmd({ "BufReadPre", "BufNewFile" }, {
	group = set_filetype,
	pattern = { "*.md.gpg" },
	callback = function()
		opt_local.filetype = "markdown"
	end,
})

local all_filetypes = augroup("AllFileTypesLocalOptions")
autocmd({ "FileType" }, {
	group = all_filetypes,
	pattern = { "*" },
	callback = function()
		opt_local.formatoptions = opt_local.formatoptions - "t" + "c" + "r" - "o" - "q" - "a" + "n" - "2" + "l" + "j"
		opt_local.laststatus = 3
	end,
})
autocmd({ "FileType" }, {
	group = all_filetypes,
	pattern = { "*" },
	callback = function()
		require("config.functions").RestoreCmdHeight()
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
	end,
})

local quit = augroup("FtQToQuit")
autocmd({ "FileType" }, {
	group = quit,
	pattern = { "qf", "help", "man", "lspinfo", "copilot.*", "startuptime" },
	callback = function()
		map("n", "q", map_cmd("close"), { silent = true, noremap = true, buffer = true })
		api.nvim_set_option("buflisted", false)
	end,
})

-- Alpha
local alpha = augroup("AlphaDashboard")
autocmd({ "User" }, {
	group = alpha,
	pattern = "AlphaReady",
	callback = function()
		opt_local.ruler = false
		opt_local.laststatus = 0
	end,
})
autocmd({ "BufUnload" }, {
	group = alpha,
	pattern = "<buffer>",
	callback = function()
		opt_local.ruler = true
		opt_local.laststatus = 3
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

local view = augroup("SaveLoadBufferView")
autocmd({ "BufWinLeave", "QuitPre" }, {
	group = view,
	pattern = file_pattern,
	callback = function()
		cmd.mkview()
	end,
})
autocmd({ "BufWinEnter" }, {
	group = view,
	pattern = file_pattern,
	callback = function()
		cmd.loadview()
	end,
})

-- Highlights
local highlights = augroup("CustomHighlights")
autocmd({ "WinEnter" }, {
	group = highlights,
	pattern = file_pattern,
	callback = function()
		local colors = require("kanagawa.colors").setup()
		cmd.highlight({ "CursorLine", "gui=bold", "cterm=bold" })
		cmd.highlight({ "Scrollbar", "guibg=" .. colors.sumiInk2 })
		cmd.highlight({ "illuminatedCurWord", "cterm=italic", "gui=italic" })
		api.nvim_set_hl(0, "IlluminatedWordText", { link = "CursorLine" })
		api.nvim_set_hl(0, "IlluminatedWordRead", { link = "CursorLine" })
		api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "CursorLine" })
	end,
})

-- Cursorline
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

-- Formatting
local formatting = augroup("BufFormatting")
autocmd({ "BufWritePre" }, {
	group = formatting,
	pattern = file_pattern,
	callback = function()
		vim.lsp.buf.format({
			async = false,
			filter = function(client)
				return client.name ~= "html"
			end,
		})
	end,
})

-- Lua reload
local write_source = augroup("WritePostReload")
autocmd({ "BufWritePost" }, {
	group = write_source,
	pattern = "*/lua/config/*.lua",
	callback = function(args)
		if #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) == 0 then
			local file = vim.split(args.file, "lua/config/", true)[2]
			local config = "config." .. vim.split(file, ".lua", true)[1]
			R(config)
		end
	end,
})
