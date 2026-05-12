local conjure_filetypes = {
  "clojure",
  "fennel",
  "scheme",
  "lisp",
  "racket",
  "lua",
}

local function configure_conjure()
  -- Conjure defaults made explicit for quick reference.
  -- <localleader> is <Space> in this config.
  vim.g["conjure#mapping#prefix"] = "<localleader>"
  vim.g["conjure#mapping#log_split"] = "ls"
  vim.g["conjure#mapping#log_vsplit"] = "lv"
  vim.g["conjure#mapping#log_tab"] = "lt"
  vim.g["conjure#mapping#log_buf"] = "le"
  vim.g["conjure#mapping#log_toggle"] = "lg"
  vim.g["conjure#mapping#log_close_visible"] = "lq"
  vim.g["conjure#mapping#log_reset_soft"] = "lr"
  vim.g["conjure#mapping#log_reset_hard"] = "lR"
  vim.g["conjure#mapping#log_jump_to_latest"] = "ll"
  vim.g["conjure#mapping#eval_current_form"] = "ee"
  vim.g["conjure#mapping#eval_comment_current_form"] = "ece"
  vim.g["conjure#mapping#eval_root_form"] = "er"
  vim.g["conjure#mapping#eval_comment_root_form"] = "ecr"
  vim.g["conjure#mapping#eval_word"] = "ew"
  vim.g["conjure#mapping#eval_comment_word"] = "ecw"
  vim.g["conjure#mapping#eval_replace_form"] = "e!"
  vim.g["conjure#mapping#eval_marked_form"] = "em"
  vim.g["conjure#mapping#eval_file"] = "ef"
  vim.g["conjure#mapping#eval_buf"] = "eb"
  vim.g["conjure#mapping#eval_visual"] = "E"
  vim.g["conjure#mapping#eval_motion"] = "E"
  vim.g["conjure#mapping#eval_previous"] = "ep"
  vim.g["conjure#mapping#def_word"] = "gd"
  vim.g["conjure#mapping#doc_word"] = false

  -- Clojure nREPL defaults.
  vim.g["conjure#filetype#clojure"] = "conjure.client.clojure.nrepl"
  vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
  vim.g["conjure#client#clojure#nrepl#mapping#disconnect"] = "cd"
  vim.g["conjure#client#clojure#nrepl#mapping#connect_port_file"] = "cf"
  vim.g["conjure#client#clojure#nrepl#mapping#interrupt"] = "ei"
  vim.g["conjure#client#clojure#nrepl#mapping#macro_expand_1"] = "x1"
  vim.g["conjure#client#clojure#nrepl#mapping#macro_expand"] = "xr"
  vim.g["conjure#client#clojure#nrepl#mapping#macro_expand_all"] = "xa"
  vim.g["conjure#client#clojure#nrepl#mapping#last_exception"] = "ve"
  vim.g["conjure#client#clojure#nrepl#mapping#result_1"] = "v1"
  vim.g["conjure#client#clojure#nrepl#mapping#result_2"] = "v2"
  vim.g["conjure#client#clojure#nrepl#mapping#result_3"] = "v3"
  vim.g["conjure#client#clojure#nrepl#mapping#view_source"] = "vs"
  vim.g["conjure#client#clojure#nrepl#mapping#view_tap"] = "vt"
  vim.g["conjure#client#clojure#nrepl#mapping#session_clone"] = "sc"
  vim.g["conjure#client#clojure#nrepl#mapping#session_fresh"] = "sf"
  vim.g["conjure#client#clojure#nrepl#mapping#session_close"] = "sq"
  vim.g["conjure#client#clojure#nrepl#mapping#session_close_all"] = "sQ"
  vim.g["conjure#client#clojure#nrepl#mapping#session_list"] = "sl"
  vim.g["conjure#client#clojure#nrepl#mapping#session_next"] = "sn"
  vim.g["conjure#client#clojure#nrepl#mapping#session_prev"] = "sp"
  vim.g["conjure#client#clojure#nrepl#mapping#session_select"] = "ss"
  vim.g["conjure#client#clojure#nrepl#mapping#run_all_tests"] = "ta"
  vim.g["conjure#client#clojure#nrepl#mapping#run_current_ns_tests"] = "tn"
  vim.g["conjure#client#clojure#nrepl#mapping#run_alternate_ns_tests"] = "tN"
  vim.g["conjure#client#clojure#nrepl#mapping#run_current_test"] = "tc"
  vim.g["conjure#client#clojure#nrepl#mapping#refresh_changed"] = "rr"
  vim.g["conjure#client#clojure#nrepl#mapping#refresh_all"] = "ra"
  vim.g["conjure#client#clojure#nrepl#mapping#refresh_clear"] = "rc"
  vim.g["conjure#client#clojure#nrepl#mapping#auto_repl_restart"] = "car"

  vim.g["conjure#log#hud#enabled"] = true
  vim.g["conjure#log#hud#border"] = "rounded"
  vim.g["conjure#extract#tree_sitter#enabled"] = true
end

local function setup_cmp_conjure()
  local ok_cmp, cmp = pcall(require, "cmp")
  if not ok_cmp then
    return
  end
  local existing = cmp.get_config().sources or {}
  local merged = vim.deepcopy(existing)
  table.insert(merged, { name = "conjure", group_index = 4, keyword_length = 2 })
  cmp.setup.buffer({ sources = merged })
end

return {
  {
    "Olical/conjure",
    ft = conjure_filetypes,
    init = configure_conjure,
    dependencies = {
      "PaterJason/cmp-conjure",
    },
    lazy = true,
  },
  {
    "PaterJason/cmp-conjure",
    ft = conjure_filetypes,
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local group = vim.api.nvim_create_augroup("cmp_conjure_clojure", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = conjure_filetypes,
        callback = setup_cmp_conjure,
      })
    end,
    lazy = true,
  },
  {
    "julienvincent/nvim-paredit",
    ft = { "clojure", "fennel", "scheme", "lisp", "racket" },
    opts = function()
      local api = require("nvim-paredit.api")
      return {
        use_default_keys = true,
        indent = { enabled = true },
        keys = {
          -- Free <localleader>o for <leader>o (oil) since localleader == leader == <Space>.
          ["<localleader>o"] = false,
          ["<localleader>O"] = false,
          ["<localleader>kr"] = { api.raise_form, "Raise form" },
          ["<localleader>kR"] = { api.raise_element, "Raise element" },
        },
      }
    end,
  },
}
