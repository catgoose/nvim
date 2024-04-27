return {
  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "jcdickinson/http.nvim",
      build = "cargo build --workspace --release",
    },
    "hrsh7th/nvim-cmp",
  },
  event = "InsertEnter",
  config = function()
    require("codeium").setup({})
  end,
  enabled = false,
}
