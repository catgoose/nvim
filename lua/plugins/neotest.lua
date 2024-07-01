local u = require("util")
local m = u.lazy_map

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
    {
      "thenbe/neotest-playwright",
      dependencies = "nvim-telescope/telescope.nvim",
    },
  },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("neotest").setup({
      adapters = {
        require("neotest-vitest")({
          filter_dir = function(name)
            return name ~= "node_modules" and name:find("e2e") == nil
          end,
          is_test_file = function(path)
            local test = u.find_path(path, "src/.*/__tests__/.*%.test%.[jt]s$")
            local snapshot = u.find_path(path, "src/.*/__snapshots__")
            return test and not snapshot
          end,
        }),
        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
            is_test_file = function(path)
              local test = u.find_path(path, "e2e/tests/.*%.test%.[jt]s$")
              return test
            end,
            experimental = {
              telescope = {
                enabled = true,
                opts = {
                  layout_strategy = "vertical",
                  layout_config = {
                    width = 0.25,
                    height = 0.25,
                    vertical = {
                      prompt_position = "bottom",
                    },
                  },
                },
              },
            },
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
    m("<leader>m", "Neotest summary"),
    m("<leader>M", function()
      vim.cmd("NeotestPlaywrightRefresh")
      vim.cmd.write()
    end),
    m("[n", function()
      require("neotest").jump.prev({ status = "failed" })
    end),
    m("]n", function()
      require("neotest").jump.next({ status = "failed" })
    end),
    m("<leader>n", function()
      vim.g.catgoose_terminal_enable_startinsert = 0
      require("neotest").run.run()
    end),
    m("<leader>N", function()
      vim.g.catgoose_terminal_enable_startinsert = 0
      require("neotest").run.run(vim.fn.expand("%"))
    end),
    m("<leader>1", function()
      ---@diagnostic disable-next-line: missing-parameter
      require("neotest").watch.stop()
    end),
    m("<leader>2", function()
      ---@diagnostic disable-next-line: missing-parameter
      require("neotest").watch.watch()
    end),
    m("<leader>3", function()
      ---@diagnostic disable-next-line: missing-parameter
      require("neotest").watch.watch(vim.fn.expand("%"))
    end),
    m("<leader>4", function()
      require("neotest").output_panel.toggle()
    end),
    m("<leader>8", function()
      vim.g.catgoose_terminal_enable_startinsert = 1
      require("neotest").output.open({
        enter = true,
        auto_close = true,
      })
    end),
    m("<leader>9", function()
      ---@diagnostic disable-next-line: undefined-field
      require("neotest").playwright.attachment()
    end),
  },
}
