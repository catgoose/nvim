local dev = true
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
      names = false,
      extra_names = function()
        local colors = require("kanagawa.colors").setup()
        return colors.palette
      end,
    },
    -- red
    -- autumnGreen
    -- sumiInk4
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
  user_default_options = {
    names = true,
    extra_names = {
      cool = "#107dac",
      ["notcool"] = "#ee9240",
    },
    RGB = true,
    RRGGBB = true,
    RRGGBBAA = true,
    AARRGGBB = true,
    rgb_fn = false,
    hsl_fn = false,
    css = false,
    css_fn = false,
    mode = "background",
    tailwind = "both",
    sass = {
      enable = false,
      parsers = { "css" },
    },
    virtualtext = "■",
    virtualtext_inline = true,
    virtualtext_mode = "background",
    always_update = false,
  },
  buftypes = {
    "*",
    "!prompt",
    "!popup",
  },
  user_commands = true,
}
-- red

local keys = project.get_keys("nvim-colorizer.lua")

local plugin = {
  opts = opts,
  keys = keys,
  event = "BufReadPre",
}

return dev
    and vim.tbl_extend("keep", plugin, {
      dir = "~/git/nvim-colorizer.lua",
      lazy = false,
      init = function()
        vim.api.nvim_create_autocmd({ "BufReadPre" }, {
          group = vim.api.nvim_create_augroup("ColorizerReloadOnSave", { clear = true }),
          pattern = { "expect.txt" },
          callback = function(evt)
            require("colorizer").reload_on_save(evt.match)
          end,
        })
      end,
    })
  or vim.tbl_extend("keep", plugin, {
    "catgoose/nvim-colorizer.lua",
  })
