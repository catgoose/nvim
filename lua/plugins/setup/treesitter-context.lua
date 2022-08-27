require("config.utils").plugin_setup("treesitter-context", {
	enable = true,
	max_lines = 0,
	trim_scope = "outer",
	patterns = {
		default = {
			"class",
			"function",
			"method",
			-- 'for',
			-- 'while',
			-- 'if',
			-- 'switch',
			-- 'case',
		},
		--   rust = {
		--       'impl_item',
		--   },
	},
	exact_patterns = {
		-- rust = true,
	},
	zindex = 20,
	mode = "cursor",
	separator = nil,
})
