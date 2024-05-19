local dev = false
local e = vim.tbl_extend
local project = require("util.project")

local keys = project.get_keys("highlight-colors")

local opts = {
  ---Render style
  ---@usage 'background'|'foreground'|'virtual'
  -- render = "background",
  render = "background",

  ---Set virtual symbol (requires render to be set to 'virtual')
  virtual_symbol = "■",

  ---Highlight named colors, e.g. 'green'
  enable_named_colors = false,

  ---Highlight tailwind colors, e.g. 'bg-blue-500'
  enable_tailwind = false,

  ---Set custom colors
  ---Label must be properly escaped with '%' to adhere to `string.gmatch`
  --- :help string.gmatch
  custom_colors = {
    { label = "%-%-theme%-primary%-color", color = "#0f1219" },
    { label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
  },
}

local plugin = {
  keys = keys,
  opts = opts,
  event = "BufReadPre",
  enabled = false,
}

if dev == true then
  return e("keep", plugin, {
    dir = "~/git/nvim-highlight-colors",
    lazy = false,
  })
else
  return e("keep", plugin, {
    -- "brenoprata10/nvim-highlight-colors",
    "catgoose/nvim-highlight-colors",
  })
end
