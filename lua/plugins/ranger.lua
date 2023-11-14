local m = require("util").lazy_map

return {
	"kelly-lin/ranger.nvim",
	config = function()
		local ranger_nvim = require("ranger-nvim")
		local opts = {
			enable_cmds = true,
			replace_netrw = false,
			keybinds = {
				["ov"] = ranger_nvim.OPEN_MODE.vsplit,
				["oh"] = ranger_nvim.OPEN_MODE.split,
				["ot"] = ranger_nvim.OPEN_MODE.tabedit,
				["or"] = ranger_nvim.OPEN_MODE.rifle,
			},
			ui = {
				border = "rounded",
			},
		}
		ranger_nvim.setup(opts)
	end,
	event = { "BufReadPre" },
	keys = {
		-- m("<leader>R", "Ranger"),
	},
	cmd = { "Ranger" },
}
