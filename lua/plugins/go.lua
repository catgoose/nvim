-- {
--   "ray-x/go.nvim",
--   dependencies = {
--     "ray-x/guihua.lua",
--     "neovim/nvim-lspconfig",
--     "nvim-treesitter/nvim-treesitter",
--   },
--   config = function()
--     require("go").setup()
--   end,
--   event = { "CmdlineEnter" },
--   ft = { "go", "gomod" },
--   build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
-- },
return {
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "mfussenegger/nvim-dap",
    },
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    config = true,
  },
}
