local m = require("util").lazy_map

return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{
			"tpope/vim-dadbod",
			lazy = true,
		},
		{
			"kristijanhusak/vim-dadbod-completion",
			ft = { "sql", "mysql", "plsql" },
			lazy = true,
		},
		"napisani/nvim-dadbod-bg",
		build = "./install.sh",
		config = function()
			vim.cmd([[
        let g:nvim_dadbod_bg_port = '4546'
        leg g:nvim_dadbod_bg_log_file = '/tmp/nvim-dadbod-bg.log'
      ]])
		end,
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	keys = {
		m("<leader>db", "tab DBUI"),
	},
	init = function()
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_table_helpers = {
			sqlserver = {
				List = "select * from {table}",
				Count = "select count(*) from {table}",
			},
		}
	end,
	lazy = true,
}
