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
    vue = {
      tailwind = "both",
      tailwind_opts = {
        update_names = true,
      },
      -- names = true,
      -- mode = "virtualtext",
      virtualtext_inline = false,
      css = true,
    },
    typescript = {
      css = true,
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
    cmp_menu = {
      tailwind = "normal",
      always_update = true,
      css = true,
      -- tailwind = "normal",
    },
    cmp_docs = {
      always_update = true,
      css = true,
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
      RRGGBB = true,
      always_update = true,
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
    names_opts = {
      lowercase = true,
      camelcase = true,
      uppercase = true,
      strip_digits = false,
    },
    names_custom = {
      red_purple = "#107dac",
      redpurple = "#107dac",
      green_blue = "#ee9240",
      greenblue = "#ee9240",
      ["a-asdf"] = "#ff0000",
    },
    -- RGB = true,
    -- RGBA = true,
    -- RRGGBB = true,
    -- RRGGBBAA = true,
    -- AARRGGBB = true,
    -- rgb_fn = true,
    -- hsl_fn = false,
    -- css = false,
    -- css_fn = true,
    -- mode = "background",
    -- mode = "virtualtext",
    -- tailwind = "both",
    -- names = false,
    -- tailwind = "normal",
    names = true,
    -- virtualtext_inline = false,
    -- css = false,
    -- sass = {
    --   enable = true,
    --   parsers = { "css" },
    -- },
    -- virtualtext = "■",
    -- virtualtext_mode = "background",
    -- always_update = false,
  },
  user_commands = true,
  lazy_load = false,
}
-- red

local keys = project.get_keys("nvim-colorizer.lua")

local plugin = {
  opts = opts,
  keys = keys,
  event = "BufReadPre",
  -- event = "VeryLazy",
  -- branch = "lazyload",
  -- lazy = true,
  init = function()
    vim.api.nvim_create_autocmd({ "BufReadPre" }, {
      group = vim.api.nvim_create_augroup("ColorizerReloadOnSave", { clear = true }),
      pattern = { "expect.lua" },
      callback = function(evt)
        require("colorizer").reload_on_save(evt.match)
      end,
    })
  end,
  enabled = true,
}

return dev and vim.tbl_extend("keep", plugin, {
  dir = "~/git/nvim-colorizer.lua",
}) or vim.tbl_extend("keep", plugin, {
  "catgoose/nvim-colorizer.lua",
})
