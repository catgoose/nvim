local fn, api, cmd = vim.fn, vim.api, vim.cmd
local autocmd = api.nvim_create_autocmd
local config_path = "config"
local func_path = config_path .. "." .. "functions"

local M = {}

M.packer_install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local function to_tbl(v)
	if type(v) == "string" then
		v = { v }
	end
	return v
end

M.packer_config = function(bootstrap)
	local bootstrap_config = {
		display = { open_fn = require("packer.util").float },
		compile_on_sync = true,
	}
	local config = {
		profile = { enable = true, threshold = 0 },
		display = { non_interactive = false },
		autoremove = true,
		compile_on_sync = true,
		auto_clean = true,
	}

	if bootstrap then
		return bootstrap_config
	else
		return config
	end
end

M.load_nvim_config = function()
	local default_plugins = {
		"2html_plugin",
		"getscript",
		"getscriptPlugin",
		"gzip",
		"logipat",
		"netrw",
		"netrwPlugin",
		"netrwSettings",
		"netrwFileHandlers",
		"matchit",
		"tar",
		"tarPlugin",
		"rrhelper",
		"spellfile_plugin",
		"vimball",
		"vimballPlugin",
		"zip",
		"zipPlugin",
	}
	for _, plugin in pairs(default_plugins) do
		M.set_global("loaded_" .. plugin, 1)
	end

	local nvim_modules_path = "config"
	local nvim_modules = {
		"globals",
		"options",
		"functions",
		"autocmd",
		"keymaps",
	}
	for _, module in ipairs(nvim_modules) do
		local module_ok, err = pcall(require, nvim_modules_path .. "." .. module)
		if not module_ok then
			error("Error loading " .. module .. "\n\n" .. err)
		end
	end
end

M.packer_compile_done = function()
	autocmd({ "User" }, {
		pattern = "PackerCompileDone",
		callback = function()
			cmd.qall()
		end,
	})
end

M.map = function(modes, lhs, rhs, opts)
	opts = opts or { silent = true, noremap = true }
	modes = to_tbl(modes)
	for _, mode in ipairs(modes) do
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

M.map_cmd = function(cmd_arg)
	return [[<cmd>]] .. cmd_arg .. [[<cr>]]
end

M.map_plug = function(cmd_arg)
	return [[<Plug>]] .. cmd_arg
end

M.map_func = function(cmd_arg, func_arg)
	func_arg = func_arg or ""
	return function()
		return require(func_path)[cmd_arg](func_arg)
	end
end

M.plugin_updates = M.map_cmd("PackerSync") .. M.map_cmd("MasonToolsUpdate") .. M.map_cmd("TSUpdate")

M.set_global = function(name, value)
	api.nvim_set_var(name, value)
end

M.get_global = function(name)
	return api.nvim_get_var(name)
end

M.plugin_config = function(plugin)
	return [[require("plugins.setup.]] .. plugin .. [[")]]
end

M.get_mason_tools = function()
	return {
		"angular-language-server",
		"bash-language-server",
		"codespell",
		"cssmodules-language-server",
		"css-lsp",
		"diagnostic-languageserver",
		"dockerfile-language-server",
		"eslint-lsp",
		"fixjson",
		"hadolint",
		"json-lsp",
		"lua-language-server",
		"markdownlint",
		"misspell",
		"prettierd",
		"shellcheck",
		"shfmt",
		"stylua",
		"typescript-language-server",
	}
end

M.require_plugin = function(plugin_name)
	local plugin_ok, plugin = pcall(require, plugin_name)
	if not plugin_ok then
		error([[Error loading plugin: ]] .. plugin_name)
	end
	return plugin
end

M.plugin_setup = function(plugin_name, setup_tbl)
	setup_tbl = setup_tbl or {}
	local plugin = M.require_plugin(plugin_name)
	plugin.setup(setup_tbl)
end

M.diagnostic_signs = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}
	for _, sign in ipairs(signs) do
		fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	return signs
end

M.create_augroup = function(group, opts)
	opts = opts or { clear = true }
	return api.nvim_create_augroup(group, opts)
end

M.nonrelative_win_count = function()
	local wins = api.nvim_list_wins()
	local non_relative = 0
	for _, win in ipairs(wins) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative == "" then
			non_relative = non_relative + 1
		end
	end
	return non_relative
end

M.display_winbar = function()
	return M.nonrelative_win_count() > 1
end

return M
