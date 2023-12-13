local m = require("util").lazy_map
local leet_arg = "leetcode.nvim"

return {
	{
		"dstein64/vim-startuptime",
		lazy = false,
	},
	{
		"litao91/lsp_lines",
		priority = 900,
		config = true,
		-- enabled = true,
	},
	{
		"axelvc/template-string.nvim",
		opts = {
			filetypes = { "html", "typescript", "javascript", "typescriptreact", "javascriptreact", "python", "vue" },
		},
		event = "BufReadPre",
	},
	{
		"chentoast/marks.nvim",
		config = true,
		event = "BufReadPre",
	},
	{
		"wakatime/vim-wakatime",
		event = "BufReadPre",
	},
	{
		"lambdalisue/suda.vim",
		event = "BufReadPre",
	},
	{
		"romainl/vim-cool",
		event = "BufReadPre",
	},
	{
		"famiu/bufdelete.nvim",
		dependencies = "schickling/vim-bufonly",
		cmd = { "BufOnly", "Bdelete" },
	},
	{
		"MaximilianLloyd/tw-values.nvim",
		config = true,
		lazy = true,
		ft = { "typescript", "typescriptreact", "vue", "html", "svelt", "astro" },
	},
	{
		"tpope/vim-fugitive",
		cmd = { "Git" },
		keys = {
			m("<leader>gi", "Git"),
		},
	},
	{
		"zeioth/garbage-day.nvim",
		dependencies = "neovim/nvim-lspconfig",
		event = "VeryLazy",
		config = true,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	{
		"kawre/leetcode.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-treesitter/nvim-treesitter",
			"rcarriga/nvim-notify",
			"nvim-tree/nvim-web-devicons",
			"3rd/image.nvim",
		},
		opts = {
			image = true,
			lang = "typescript",
			--[[
      Run inside of ~/.local/share/nvim/leetcode
      npm install @typescript-eslint/eslint-plugin @typescript-eslint/parser
      add to .eslintrc.json:
        {
          "root": true,
          "overrides": [
            {
              "files": [
                "*.ts",
                "*.js"
              ],
              "extends": [
                "eslint:recommended",
                "plugin:@typescript-eslint/recommended"
              ],
              "parser": "@typescript-eslint/parser"
            }
          ]
        }
      ]]
		},
		lazy = false,
	},
}
