local m = require("util").lazy_map

return {
	"CKolkey/ts-node-action",
	keys = {
		m("<leader>i", [[lua require("ts-node-action").node_action()]]),
	},
}
