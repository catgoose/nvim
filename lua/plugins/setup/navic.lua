require("config.utils").plugin_setup("nvim-navic", {
	disable_icons = false,
	icons = {
		["class-name"] = " ",
		["function-name"] = " ",
		["method-name"] = " ",
		["container-name"] = "⛶ ",
		["tag-name"] = "炙",
	},
	languages = {
		["json"] = {
			icons = {
				["array-name"] = " ",
				["object-name"] = " ",
				["null-name"] = "[] ",
				["boolean-name"] = "ﰰﰴ ",
				["number-name"] = "# ",
				["string-name"] = " ",
			},
		},
		["toml"] = {
			icons = {
				["table-name"] = " ",
				["array-name"] = " ",
				["boolean-name"] = "ﰰﰴ ",
				["date-name"] = " ",
				["date-time-name"] = " ",
				["float-name"] = " ",
				["inline-table-name"] = " ",
				["integer-name"] = "# ",
				["string-name"] = " ",
				["time-name"] = " ",
			},
		},
		["yaml"] = {
			icons = {
				["mapping-name"] = " ",
				["sequence-name"] = " ",
				["null-name"] = "[] ",
				["boolean-name"] = "ﰰﰴ ",
				["integer-name"] = "# ",
				["float-name"] = " ",
				["string-name"] = " ",
			},
		},
	},
	highlight = false,
	separator = " > ",
	depth = 0,
	depth_limit_indicator = "..",
})
