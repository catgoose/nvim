local m = require("util").lazy_map

return {
	"ariel-frischer/bmessages.nvim",
	event = "CmdlineEnter",
	config = true,
	keys = {
		m("<leader>bm", "Bmessages"),
	},
}
