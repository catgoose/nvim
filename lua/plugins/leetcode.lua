local leet_arg = "leetcode.nvim"

local opts = {
  lang = "golang",
  -- lang = "typescript",
  -- lang = "javascript",
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
          ],
          "env": {
            "browser": true,
            "node": true
          }
        }
      ]]
  -- directory = vim.fn.expand("$HOME") .. "/git/dotfiles/leetcode",
  storage = {
    home = vim.fn.expand("$HOME") .. "/git/dotfiles/leetcode",
    cache = vim.fn.stdpath("cache") .. "/leetcode",
  },
  arg = leet_arg,
  keys = {
    toggle = { "q" },
    confirm = { "<CR>" },
    reset_testcases = "r",
    use_testcase = "U",
    focus_testcases = "H",
    focus_result = "L",
  },
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
