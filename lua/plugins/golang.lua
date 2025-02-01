return {
  {
    "Jay-Madden/auto-fix-return.nvim",
    config = function()
      require("auto-fix-return").setup({})
    end,
    lazy = false,
    enabled = true,
  },
  {
    "jack-rabe/impl.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      layout_strategy = "vertical",
      layout_config = {
        width = 0.5,
      },
    },
  },
  {
    "catgoose/templ-goto-definition",
    ft = { "go", "templ" },
    config = true,
  },
}
