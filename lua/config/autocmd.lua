local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local opt_local = vim.opt_local
local cmd = vim.cmd
local o = vim.o

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

--[[ local file_types = {
	"typescript",
	"html",
	"css",
	"scss",
	"sass",
	"json",
	"fish",
	"markdown",
	"sh",
	"lua",
}
]]
local set_filetype = augroup("SetFileTypes", { clear = true })
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

local all_filetypes = augroup("AllFileTypes", { clear = true })
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

local alpha = augroup("AlphaDashboard", { clear = true })
autocmd({ "User" }, {
	group = alpha,
	pattern = "AlphaReady",
	callback = function()
		vim.cmd.FocusToggle()
		opt_local.ruler = false
		opt_local.laststatus = 0
		o.winbar = ""
	end,
})
autocmd({ "BufUnload" }, {
	group = alpha,
	pattern = "<buffer>",
	callback = function()
		vim.cmd.FocusToggle()
		opt_local.ruler = true
		opt_local.laststatus = 3
		o.winbar = "%=%m %t"
	end,
})

local buffer = augroup("BufferDetectChanges", { clear = true })
autocmd({ "FocusGained", "BufEnter" }, {
	group = buffer,
	pattern = file_pattern,
	callback = function()
		cmd.checktime()
	end,
})

local view = augroup("SaveLoadBufferView", { clear = true })
autocmd({ "BufWinLeave" }, {
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
		cmd([[:silent! loadview]])
	end,
})

-- TODO: convert this to LUA
vim.cmd([[
augroup illuminate_augroup
    autocmd!
    autocmd BufReadPre * hi illuminatedCurWord cterm=italic gui=italic
augroup END
]])

local formatting = augroup("BufFormatting", { clear = true })
autocmd({ "BufWritePre" }, {
	group = formatting,
	pattern = file_pattern,
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

local markdown = augroup("MarkdownWrap", { clear = true })
autocmd({ "FileType" }, {
	group = markdown,
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

local quit = augroup("QToQuit", { clear = true })
autocmd({ "FileType" }, {
	group = quit,
	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir" },
	callback = function()
		vim.cmd([[ 
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
	end,
})
