local dev = true
local project = require("util.project")

local opts = {
  -- filetypes = {
  --   "*",
  --   "!dashboard",
  --   ps1 = {
  --     RGB = false,
  --     css = false,
  --   },
  --   vue = {
  --     tailwind = "both",
  --     tailwind_opts = {
  --       update_names = true,
  --     },
  --     -- tailwind = true,
  --     virtualtext = "●",
  --     virtualtext_inline = true,
  --     mode = "virtualtext",
  --     always_update = true,
  --     RRGGBBAA = true,
  --     AARRGGBB = true,
  --     css = true,
  --   },
  --   typescript = {
  --     css = true,
  --   },
  --   javascript = {
  --     css = false,
  --   },
  --   json = {
  --     css = false,
  --   },
  --   sh = {
  --     css = false,
  --   },
  --   mason = {
  --     css = false,
  --   },
  --   lazy = {
  --     RGB = false,
  --     css = false,
  --   },
  --   cmp_menu = {
  --     tailwind = "normal",
  --     always_update = true,
  --     css = true,
  --     -- tailwind = "normal",
  --   },
  --   cmp_docs = {
  --     always_update = true,
  --     css = true,
  --   },
  --   TelescopeResults = {
  --     RGB = false,
  --   },
  --   -- lua = {
  --   -- names = true,
  --   -- tailwind = true,
  --   -- names_custom = {
  --   -- ["  FIX:  "] = "#FF0000",
  --   -- one_two = "#017dac",
  --   -- ["three=four"] = "#3700c2",
  --   -- ["five@six"] = "#e9e240",
  --   -- ["seven!eight"] = "#a9e042",
  --   -- ["nine!!ten"] = "#09e392",
  --   -- },
  --   -- names_custom = function()
  --   --   local colors = require("kanagawa.colors").setup()
  --   --   return colors.palette
  --   -- end,
  --   -- },
  --   markdown = {
  --     RGB = false,
  --     RRGGBB = true,
  --     always_update = true,
  --   },
  --   checkhealth = {
  --     names = false,
  --   },
  --   sshconfig = {
  --     names = false,
  --   },
  --   NeogitLogView = {
  --     RGB = false,
  --   },
  --   NeogitStatus = {
  --     RGB = false,
  --   },
  --   Mason = {
  --     names = false,
  --   },
  -- },
  -- buftypes = {
  --   "*",
  --   "!prompt",
  --   "!popup",
  -- },
  -- user_default_options = {
  --   -- names_opts = {
  --   --   lowercase = true,
  --   --   camelcase = true,
  --   --   uppercase = true,
  --   --   strip_digits = false,
  --   -- },
  --   -- RGB = true,
  --   -- RGBA = true,
  --   -- RRGGBB = true,
  --   -- RRGGBBAA = true,
  --   -- AARRGGBB = true,
  --   -- rgb_fn = true,
  --   -- hsl_fn = false,
  --   -- css = false,
  --   -- css_fn = true,
  --   -- mode = "background",
  --   -- mode = "virtualtext",
  --   -- names = false,
  --   -- names_custom = {
  --   --   [" NOTE:"] = "#5CA204",
  --   -- ["TODO: "] = "#3457D5",
  --   -- [" WARN: "] = "#EAFE01",
  --   -- ["  FIX:  "] = "#FF0000",
  --   -- one_two = "#017dac",
  --   -- ["three=four"] = "#3700c2",
  --   -- ["five@six"] = "#e9e240",
  --   -- ["seven!eight"] = "#a9e042",
  --   -- ["nine!!ten"] = "#09e392",
  --   -- },
  --   -- tailwind = true,
  --   -- css = true,
  --   -- names = true,
  --   -- virtualtext_inline = false,
  --   -- css = false,
  --   -- sass = {
  --   --   enable = true,
  --   --   parsers = { "css" },
  --   -- },
  --   -- virtualtext = "■",
  --   -- virtualtext_mode = "background",
  --   -- always_update = false,
  -- },
  -- user_commands = true,
  -- lazy_load = false,
  filetypes = {
    "*",
    html = {
      names = true,
      names_opts = {
        lowercase = true,
        uppercase = true,
        camelcase = true,
        strip_digits = false,
      },
      names_custom = {
        html1 = "#0000ff",
        html2 = "#00ff00",
        html3 = "#ff0000",
        html4 = "#0eae90",
        html5 = "#f0f000",
        html6 = "#fa0ce0",
      },
      tailwind = true,
    },
    lua = {
      names = true,
      names_opts = {
        lowercase = true,
        uppercase = true,
        camelcase = true,
        strip_digits = false,
      },
      names_custom = {
        lua1 = "#ffefaf",
        lua2 = "#3f0fb0",
        lua3 = "#f000f0",
        lua4 = "#902f00",
      },
      tailwind = false,
    },
    css = {
      names = true,
      names_custom = {
        css1 = "#fac00e",
        css2 = "#f0c0ae",
      },
    },
    javascript = { names = true },
    javascriptreact = { names = true },
  },
  user_default_options = {
    names = true,
    names_custom = {
      html1 = "#000000",
      html2 = "#000000",
      lua1 = "#000000",
      lua2 = "#000000",
      css1 = "#000000",
    },
    RGB = true,
    RRGGBB = true,
    RRGGBBAA = true,
    AARRGGBB = true,
    rgb_fn = true,
    hsl_fn = true,
    css = true,
    css_fn = true,
    mode = "background",
    sass = { enable = false, parsers = { "css" } },
    virtualtext = "",
    virtualtext_inline = true,
    virtualtext_mode = "foreground",
    always_update = false,
  },
  buftypes = {},
  user_commands = true,
  lazy_load = false,
}

local keys = project.get_keys("nvim-colorizer.lua")

local plugin = {
  opts = opts,
  keys = keys,
  event = "BufReadPre",
  -- event = "VeryLazy",
  -- branch = "lazyload",
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
