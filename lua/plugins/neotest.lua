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
            is_test_file = function(file_path)
              return string.match(file_path, "e2e/tests")
            end,
          },
        }),
      },
      consumers = {
        playwright = require("neotest-playwright.consumers").consumers,
      },
    })
  end,
  cmd = {
    "Neotest",
    "NeotestPlaywrightProject",
    "NeotestPlaywrightPreset",
    "NeotestPlaywrightRefresh",
  },
  keys = {
    m("<leader>m", "Neotest summary"),
    --  TODO: 2024-06-02 - create UserCommands
    m("<leader>n", function()
      vim.g.terminal_enable_startinsert = 0
      require("neotest").run.run()
    end),
    m("<leader>tr", function()
      vim.g.terminal_enable_startinsert = 0
      require("neotest").run.run()
    end),
    m("<leader>tw", function()
      vim.g.terminal_enable_startinsert = 0
      require("neotest").watch.toggle()
    end),
    m("<leader>tW", function()
      vim.g.terminal_enable_startinsert = 0
      require("neotest").watch.toggle(vim.fn.expand("%"))
    end),
    m("<leader>tf", function()
      vim.g.terminal_enable_startinsert = 0
      require("neotest").run.run(vim.fn.expand("%"))
    end),
    --  TODO: 2024-06-02 - This is duplicated in utils.lua hover_handler
    m("<leader>tO", function()
      require("neotest").output.open({
        enter = true,
        auto_close = true,
      })
    end),
    m("<leader>to", function()
      require("neotest").output_panel.toggle()
    end),
  },
}
