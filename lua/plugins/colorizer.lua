local dev = false
local project = require("util.project")

local function is_comment_on_line(line_num, bufnr, filetype)
  local parser_ok, parser = pcall(vim.treesitter.get_parser, bufnr, filetype)
  if not parser_ok or not parser then
    return
  end
  local tree = parser:parse()
  if not tree or not tree[1] then
    return
  end
  local node = tree[1]:root()
  if not node then
    return
  end

  local query_ok, query = pcall(vim.treesitter.query.parse, filetype, "(comment) @comment")
  if not query_ok or not query then
    return
  end

  for _, capture in query:iter_captures(node, 0) do
    local start_row, _, end_row, _ = capture:range()
    if
      (start_row == line_num and end_row == line_num) -- single line comment
      or (start_row <= line_num and end_row >= line_num) --[[ block comment ]]
    then
      return true
    end
  end
end

local opts = {
  filetypes = {
    "*",
    "!dashboard",
    go = {
      parsers = {
        names = { uppercase = false, camelcase = false },
      },
    },
    ps1 = {
      parsers = {
        hex = { enable = false },
      },
    },
    typescript = {
      parsers = { css = true },
    },
    javascript = {
      parsers = { css = false },
    },
    json = {
      parsers = { css = false },
    },
    sh = {
      parsers = { css = false },
    },
    mason = {
      parsers = { css = false },
    },
    lazy = {
      parsers = {
        hex = { rgb = false },
        css = false,
      },
    },
    cmp_menu = {
      parsers = {
        tailwind = { enable = true, mode = "normal" },
        css = true,
      },
      always_update = true,
    },
    cmp_docs = {
      parsers = { css = true },
      always_update = true,
    },
    TelescopeResults = {
      parsers = {
        hex = { rgb = false },
      },
    },
    markdown = {
      parsers = {
        hex = { enable = true, rgb = false, rrggbb = true },
      },
      always_update = true,
    },
    checkhealth = {
      parsers = {
        names = { enable = false },
      },
    },
    sshconfig = {
      parsers = {
        names = { enable = false },
      },
    },
    NeogitLogView = {
      parsers = {
        hex = { rgb = false },
      },
    },
    NeogitStatus = {
      parsers = {
        hex = { rgb = false },
        css = false,
      },
    },
    Mason = {
      parsers = {
        names = { enable = false },
      },
    },
    make = {
      parsers = {
        names = { enable = false },
      },
    },
    templ = {
      parsers = {
        tailwind = { enable = true, mode = "both" },
      },
    },
  },
  buftypes = {
    "*",
    "!prompt",
    "!popup",
  },
  options = {
    parsers = {
      names = {
        enable = true,
        lowercase = true,
        camelcase = true,
        uppercase = true,
        strip_digits = false,
      },
      hex = {
        enable = true,
        rgb = true,
        rgba = true,
        rrggbb = true,
        rrggbbaa = true,
        aarrggbb = true,
      },
      rgb = { enable = true },
      hsl = { enable = true },
      oklch = { enable = true },
      css = true,
      css_fn = true,
      xterm = { enable = true },
      tailwind = { enable = true, mode = "lsp" },
      sass = {
        enable = true,
        parsers = { css = true },
      },
    },
    display = {
      mode = "background",
      virtualtext = {
        char = "■",
        position = false,
        hl_mode = "foreground",
      },
    },
    always_update = true,
  },
  user_commands = true,
  lazy_load = true,
}

local keys = project.get_keys("nvim-colorizer.lua")

local plugin = {
  opts = opts,
  keys = keys,
  event = "VeryLazy",
  init = function()
    vim.api.nvim_create_autocmd({ "BufReadPre" }, {
      group = vim.api.nvim_create_augroup("ColorizerReloadOnSave", { clear = true }),
      pattern = { "expect.lua" },
      callback = function(evt)
        require("colorizer").reload_on_save(evt.match)
      end,
    })
  end,
}

return dev and vim.tbl_extend("keep", plugin, {
  dir = "~/git/nvim-colorizer.lua",
}) or vim.tbl_extend("keep", plugin, {
  "catgoose/nvim-colorizer.lua",
  branch = "master",
})
