local leet_arg = "leetcode.nvim"

local opts = {
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
	directory = vim.fn.expand("$HOME") .. "/git/dotfiles/leetcode",
	arg = leet_arg,
	toggle_key = { "<Esc>" },
}

return {
	"kawre/leetcode.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-treesitter/nvim-treesitter",
		"rcarriga/nvim-notify",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("leetcode").setup(opts)
		vim.cmd([[silent! Copilot disable]])
		vim.g.leetcode = true
	end,
	lazy = leet_arg ~= vim.fn.argv()[1],
}
