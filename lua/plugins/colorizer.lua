local dev = false
local project = require("util.project")

local opts = {
  filetypes = {
    "*",
    "!dashboard",
    ps1 = {
      RGB = false,
      css = false,
    },
    typescript = {
      css = false,
    },
    javascript = {
      css = false,
    },
    json = {
      css = false,
    },
    sh = {
      css = false,
    },
    mason = {
      css = false,
    },
    lazy = {
      RGB = false,
      css = false,
    },
    cmp_docs = {
      always_update = true,
    },
    cmp_menu = {
      always_update = true,
    },
    TelescopeResults = {
      RGB = false,
    },
    lua = {
      names = true,
      names_custom = function()
        local colors = require("kanagawa.colors").setup()
        return colors.palette
      end,
    },
    markdown = {
      RGB = false,
    },
    checkhealth = {
      names = false,
    },
    sshconfig = {
      names = false,
    },
    NeogitLogView = {
      RGB = false,
    },
    NeogitStatus = {
      RGB = false,
    },
    Mason = {
      names = false,
    },
  },
  buftypes = {
    "*",
    "!prompt",
    "!popup",
  },
  user_default_options = {
    names = true,
    names_custom = {
      red_purple = "#107dac",
      redpurple = "#107dac",
      green_blue = "#ee9240",
      greenblue = "#ee9240",
    },
    -- RGB = true,
    -- RRGGBB = true,
    -- RRGGBBAA = true,
    -- AARRGGBB = true,
    -- rgb_fn = true,
    -- hsl_fn = false,
    css = true,
    -- css_fn = false,
    -- mode = "background",
    -- tailwind = "both",
    -- css = false,
    -- sass = {
    --   enable = true,
    --   parsers = { "css" },
    -- },
    -- virtualtext = "■",
    -- virtualtext_inline = true,
    -- virtualtext_mode = "background",
    always_update = true,
  },
  user_commands = true,
}
-- red

local keys = project.get_keys("nvim-colorizer.lua")

local plugin = {
  opts = opts,
  keys = keys,
  event = "BufReadPre",
  lazy = false,
  init = function()
    vim.api.nvim_create_autocmd({ "BufReadPre" }, {
      group = vim.api.nvim_create_augroup("ColorizerReloadOnSave", { clear = true }),
      pattern = { "expect.lua" },
      callback = function(evt)
        require("colorizer").reload_on_save(evt.match)
      end,
    })
  end,
  -- enabled = true,
}

return dev and vim.tbl_extend("keep", plugin, {
  dir = "~/git/nvim-colorizer.lua",
}) or vim.tbl_extend("keep", plugin, {
  "catgoose/nvim-colorizer.lua",
})
