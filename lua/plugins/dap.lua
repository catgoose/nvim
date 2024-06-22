local m = require("util").lazy_map

return {
  {
    "mfussenegger/nvim-dap",
    event = "BufReadPre",
    -- keys = {
    -- 	m("<leader>dc", [[DapContinue]]),
    -- 	m("<leader>db", [[DapToggleBreakpoint]]),
    -- 	m("<leader>di", [[DapStepInto]]),
    -- 	m("<leader>do", [[DapStepOut]]),
    -- 	m("<leader>dl", [[DapStepOver]]),
    -- },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPre",
  },
  {
    "rcarriga/nvim-dap-ui",
    config = true,
    -- keys = {
    -- 	m("<leader>n", [[lua require("dapui").toggle()]]),
    -- },
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/cmp-dap",
    },
  },
  {
    "ofirgall/goto-breakpoints.nvim",
    event = "BufReadPre",
    keys = {
      m("]r", [[lua require('goto-breakpoints').next()]]),
      m("[r", [[lua require('goto-breakpoints').prev()]]),
    },
    dependencies = "mfussenegger/nvim-dap",
  },
}
