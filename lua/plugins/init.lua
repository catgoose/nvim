-- local u = require("util")
-- local m = u.lazy_map

return {
  {
    "lambdalisue/suda.vim",
    event = "BufReadPost",
    enabled = false,
  },
  {
    "famiu/bufdelete.nvim",
    dependencies = "schickling/vim-bufonly",
    cmd = { "BufOnly", "Bdelete" },
  },
  {
    "romainl/vim-cool",
    event = "BufReadPost",
  },
  {
    "folke/neoconf.nvim",
    lazy = true,
  },
  {
    "seblj/roslyn.nvim",
    ft = "cs",
    config = true,
  },
  {
    {
      "Olical/conjure",
      ft = { "clojure", "fennel", "python", "lisp" },
      lazy = true,
    },
    {
      "gpanders/nvim-parinfer",
      config = true,
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    config = {
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = { cpp = true },
      -- color = {
      --   suggestion_color = "#ffffff",
      --   cterm = 244,
      -- },
      log_level = "off",
      disable_inline_completion = false,
      disable_keymaps = false,
    },
    init = function()
      local kanagawa = require("kanagawa.colors").setup({ theme = "wave" })
      local colors = kanagawa.palette
      vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = colors.springGreen })
    end,
    event = "InsertEnter",
    lazy = true,
  },
}
