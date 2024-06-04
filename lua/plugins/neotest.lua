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
    ---@diagnostic disable-next-line: missing-fields
    require("neotest").setup({
      adapters = {
        require("neotest-vitest")({
          filter_dir = function(name)
            return name ~= "node_modules" and name:find("e2e") == nil
          end,
          is_test_file = function(file_path)
            return file_path:find("src/*/__tests__") == nil
          end,
        }),
        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
            is_test_file = function(file_path)
              return file_path:find("e2e/tests/.*%.test%.[jt]s$") ~= nil
            end,
          },
        }),
      },
      consumers = {
        playwright = require("neotest-playwright.consumers").consumers,
      },
      quickfix = {
        enabled = true,
        open = false,
      },
      output = {
        enabled = true,
        open_on_run = "short",
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
    --  TODO: 2024-06-04 - wrap these in pcall
    m("[n", function()
      require("neotest").jump.prev({ status = "failed" })
    end),
    m("]n", function()
      require("neotest").jump.next({ status = "failed" })
    end),
    m("<leader>m", "Neotest summary"),
    m("<leader>n", function()
      vim.g.terminal_enable_startinsert = 0
      require("neotest").watch.watch()
    end),
    m("<leader>N", function()
      vim.g.terminal_enable_startinsert = 0
      require("neotest").watch.watch(vim.fn.expand("%"))
    end),
    m("<leader>1", function()
      ---@diagnostic disable-next-line: missing-parameter
      require("neotest").watch.stop()
    end),
    m("<leader>8", function()
      require("neotest").output.open({
        enter = true,
        auto_close = true,
      })
    end),
    m("<leader>9", function()
      require("neotest").output_panel.toggle()
    end),
  },
}
