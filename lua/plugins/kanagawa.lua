local overrides = function(colors)
  local p = colors.palette
  return {
    CursorLine = {
      bold = true,
      italic = true,
      bg = p.sumiInk5,
    },
    Visual = {
      bold = true,
    },
    TreesitterContextBottom = {
      link = "Visual",
    },
    IlluminatedCurWord = {
      italic = true,
    },
    IlluminatedWordText = {
      link = "CursorLine",
      italic = true,
    },
    IlluminatedWordRead = {
      link = "CursorLine",
      italic = true,
    },
    IlluminatedWordWrite = {
      link = "CursorLine",
      italic = true,
    },
    Folded = {
      bg = p.sumiInk3,
    },
    StatusColumnFoldClosed = {
      fg = p.springViolet1,
      bold = false,
    },
    DashboardHeader = {
      fg = p.peachRed,
      bg = p.sumiInk3,
    },
    DashboardIcon = {
      fg = p.springBlue,
      bg = p.sumiInk3,
    },
    DashboardDesc = {
      fg = p.fujiWhite,
      bg = p.sumiInk3,
      italic = true,
    },
    DashboardKey = {
      fg = p.lightBlue,
      bg = p.sumiInk3,
      bold = true,
    },
    Pmenu = {
      fg = p.fujiWhite,
      bg = p.waveBlue1,
    },
    PmenuSel = {
      fg = p.waveBlue1,
      bg = p.springViolet2,
      bold = true,
    },
    UfoFoldedBg = {
      bg = p.waveBlue1,
      bold = true,
    },
    IdentScope = {
      fg = p.oniViolet2,
    },
    MarkdownFence = {
      bg = p.sumiInk1,
      italic = true,
    },
    NeotestAdapterName = {
      fg = p.peachRed
    },
    NeotestDir = {
      fg = p.crystalBlue,
    },
    NeotestExpandMarker = {
      fg = p.sumiInk5
    },
    NeotestFailed = {
      fg = p.samuraiRed
    },
    NeotestFile = {
      fg = p.crystalBlue,
    },
    NeotestFocused = {
      bold = true,
      underline = true
    },
    NeotestIndent = {
      fg = p.sumiInk5
    },
    NeotestMarked = {
      fg = p.surimiOrange,
      italic = true
    },
    NeotestNamespace = {
      fg = p.crystalBlue,
    },
    NeotestPassed = {
      fg = p.springGreen
    },
    NeotestRunning = {
      fg = p.autumnYellow
    },
    NeotestWinSelect = {
      fg = p.waveAqua1
    },
    NeotestSkipped = {
      fg = p.springBlue
    },
    NeotestTarget = {
      fg = p.peachRed
    },
    NeotestTest = {
      fg = p.oldWhite
    },
    NeotestUnknown = {
      fg = p.katanaGray
    },
    NeotestWatching = {
      fg = p.autumnYellow
    },
  }
end

local config = function()
  require("kanagawa").setup({
    compile = false,
    undercurl = true,
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,
    dimInactive = true,
    terminalColors = true,
    colors = {
      palette = {},
      theme = {
        wave = {},
        lotus = {},
        dragon = {},
        all = {
          ui = {
            bg_gutter = "none",
          },
        },
      },
    },
    overrides = overrides,
  })
  vim.cmd.colorscheme("kanagawa-wave")
end

return {
  -- "rebelot/kanagawa.nvim",
  dir = "~/git/kanagawa.nvim",
  config = config,
  lazy = false,
  priority = 1000,
}
