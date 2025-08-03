local dev = true
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
      names_opts = {
        uppercase = false,
        camelcase = false,
      },
    },
    ps1 = {
      RGB = false,
      css = false,
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
    },
    cmp_docs = {
      always_update = true,
      css = true,
    },
    TelescopeResults = {
      RGB = false,
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
      css = false,
    },
    Mason = {
      names = false,
    },
    make = {
      names = false,
    },
    templ = {
      tailwind = "both",
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
    names = true,
    names_exclude = {
      "Azure",
      "azure",
    },
    RGB = true,
    RGBA = true,
    RRGGBB = true,
    RRGGBBAA = true,
    AARRGGBB = true,
    rgb_fn = true,
    hsl_fn = true,
    css = true,
    css_fn = true,
    xterm = true,
    xcolor = true,
    mode = "background",
    tailwind = "lsp",
    virtualtext_inline = false,
    sass = {
      enable = true,
      parsers = { "css" },
    },
    virtualtext = "■",
    virtualtext_mode = "foreground",
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
})
