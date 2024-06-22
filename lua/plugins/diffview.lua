local m = require("util").lazy_map

--  TODO: 2024-06-21 - Create user command to view diffs between branches.
--  Prompt for branches

return {
  "sindrets/diffview.nvim",
  config = true,
  cmd = { "DiffviewOpen" },
  keys = {
    m("<leader>do", [[DiffviewOpen]]),
    m("<leader>dq", [[DiffviewClose]]),
    m("<leader>dm", [[DiffviewPrompt]]),
  },
}
