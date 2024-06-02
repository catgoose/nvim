local m = require("util").lazy_map

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
    "thenbe/neotest-playwright",
  },
  config = function()
    require("neotest").setup({
      --  TODO: 2024-06-02 - Add is_test_file and filter_dir for both adapters
      adapters = {
        require("neotest-vitest")({
          filter_dir = function(name)
            return name ~= "node_modules" and name ~= "e2e"
          end,
        }),
        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
          },
        }),
      },
    })
  end,
  cmd = { "Neotest" },
  keys = {
    m("<leader>m", "Neotest summary"),
  },
}
