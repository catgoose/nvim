local opts = {
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
	directory = "/home/jtye/git/dotfiles/leetcode",
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
		"3rd/image.nvim",
	},
	opts = opts,
	lazy = false,
}
