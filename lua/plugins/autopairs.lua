local opts = {
  disable_filetype = { "TelescopePrompt" },
  enable_check_bracket_line = false,
}

local clojure_filetypes = {
  "clojure",
  "clojurec",
  "clojurescript",
  "edn",
  "fennel",
  "lisp",
  "racket",
  "scheme",
}

local function disable_rule_for_filetypes(rule, filetypes)
  rule.not_filetypes = vim.list_extend(rule.not_filetypes or {}, filetypes)
end

local function disable_reader_quote_pairs(npairs)
  for _, pair in ipairs({ "'", "`" }) do
    for _, rule in ipairs(npairs.get_rules(pair)) do
      disable_rule_for_filetypes(rule, clojure_filetypes)
    end
  end
end

return {
  "windwp/nvim-autopairs",
  opts = opts,
  config = function(_, plugin_opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(plugin_opts)
    disable_reader_quote_pairs(npairs)
  end,
  event = "InsertEnter",
  lazy = true,
}
