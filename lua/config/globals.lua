local utils = require("config.utils")
local g = utils.set_global
local reload_ok, reload = pcall(require, "plenary.reload")
if not reload_ok then
	return
end

local reloader = reload.reload_module

-- variables
g("mapleader", " ")
g("zen_full_screen_status", 0)
g("cursorhold_updatetime", 100)

-- functions
utils.diagnostic_signs()

-- global utils
P = function(...)
	local tbl = {}
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		table.insert(tbl, vim.inspect(v))
	end

	print(table.concat(tbl, "\n"))
	return ...
end

RELOAD = function(...)
	return reloader(...)
end

R = function(name)
	RELOAD(name)
	return require(name)
end
