local u = require("util")
local t = require("util.toggle")
local m = u.lazy_map
local opts = t.toggleterm_opts
local modes = { "n", "t" }

return {
	"akinsho/toggleterm.nvim",
	opts = opts,
	version = "*",
	keys = {
		m("[1", "ToggleTermSpotify", modes),
		m("[2", "ToggleTermLazyDocker", modes),
		m("[3", "ToggleTermLazyGit", modes),
		m("[4", "ToggleTermFish", modes),
		m("[8", "ToggleTermRepl", modes),
		m("[0", "ToggleTermPowershell", modes),
		-- ToggleTasks
		m("[5", "5ToggleTerm", modes),
		m("[9", "9ToggleTerm", modes),
	},
	branch = "main",
}
