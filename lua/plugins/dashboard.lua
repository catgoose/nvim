local header = {
  [[]],
  [[]],
  [[]],
  [[]],
  [[╔══╗ ╔╗   ╔═══╗╔═══╗╔╗╔═╗    ╔═══╗╔═══╗╔═══╗╔═══╗╔═══╗╔═╗ ╔╗    ╔═══╗╔════╗╔╗ ╔╗ ╔═══╗ ╔═══╗]],
  [[║╔╗║ ║║   ║╔═╗║║╔═╗║║║║╔╝    ║╔═╗║║╔═╗║║╔═╗║║╔══╝║╔══╝║║╚╗║║    ║╔═╗║║╔╗╔╗║║║ ║║ ║╔══╝ ║╔══╝]],
  [[║╚╝╚╗║║   ║║ ║║║║ ╚╝║╚╝╝     ║╚══╗║║ ╚╝║╚═╝║║╚══╗║╚══╗║╔╗╚╝║    ║╚══╗╚╝║║╚╝║║ ║║ ║╚══╗ ║╚══╗]],
  [[║╔═╗║║║ ╔╗║╚═╝║║║ ╔╗║╔╗║     ╚══╗║║║ ╔╗║╔╗╔╝║╔══╝║╔══╝║║╚╗║║    ╚══╗║  ║║  ║║ ║║ ║╔══╝ ║╔══╝]],
  [[║╚═╝║║╚═╝║║╔═╗║║╚═╝║║║║╚╗    ║╚═╝║║╚═╝║║║║╚╗║╚══╗║╚══╗║║ ║║║    ║╚═╝║ ╔╝╚╗ ║╚═╝║╔╝╚╗  ╔╝╚╗  ]],
  [[╚═══╝╚═══╝╚╝ ╚╝╚═══╝╚╝╚═╝    ╚═══╝╚═══╝╚╝╚═╝╚═══╝╚═══╝╚╝ ╚═╝    ╚═══╝ ╚══╝ ╚═══╝╚══╝  ╚══╝  ]],
  [[]],
  [[]],
  [[]],
  [[]],
}

local center = {
  {
    desc = "Lazy sync / TSUpdate",
    key = "s",
    action = "UpdateAndSyncAll",
  },
  {
    desc = "Find files",
    key = "f",
    action = "FFFFind",
  },
  {
    desc = "Restore session",
    key = "r",
    action = "PersistenceLoad",
  },
  {
    desc = "Select session",
    key = "R",
    action = "PersistenceSelect",
  },
  {
    desc = "Empty buffer",
    key = "e",
    action = "enew",
  },
  {
    desc = "Quit",
    key = "q",
    action = "q",
  },
}

if not vim.g.lightweight then
  table.insert(center, 2, {
    desc = "One step for vimkind",
    key = "l",
    action = "OneStepForVimKindLaunch",
  })
  table.insert(center, 3, {
    desc = "Mason",
    key = "m",
    action = "Mason",
  })
  table.insert(center, 4, {
    desc = "DiffView main/master",
    key = "d",
    action = "DiffviewMain",
  })
  table.insert(center, 5, {
    desc = "DiffView prompt",
    key = "D",
    action = "DiffviewPrompt",
  })
end

local opts = {
  theme = "doom",
  hide = {
    statusline = true,
    tabline = true,
    winbar = true,
  },
  config = {
    header = header,
    center = center,
    footer = function()
      local info = { "", "" }
      local fortune = require("fortune").get_fortune()
      local footer = vim.list_extend(info, fortune)
      return footer
    end,
    vertical_center = true,
  },
}

local padding = {
  left = 4,
  right = 16,
}
for _, i in ipairs(opts.config.center) do
  i.desc = string.rep(" ", padding.left) .. i.desc .. string.rep(" ", padding.right)
end

return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = opts,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    {
      "rubiin/fortune.nvim",
      opts = {
        display_format = "mixed",
        content_type = "mixed",
      },
    },
  },
}
