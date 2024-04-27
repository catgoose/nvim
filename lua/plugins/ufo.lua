local u = require("util")
local ufo_u = require("util.ufo")
local m = u.lazy_map

local scale = u.screen_scale({ height = 0.65 })

local opts = {
  fold_virt_text_handler = require("util.ufo").handler,
  preview = {
    win_config = {
      maxheight = scale.height,
      winhighlight = "Normal:Folded",
      winblend = 0,
    },
    mappings = {
      scrollU = "<C-u>",
      scrollD = "<C-d>",
    },
  },
  close_fold_kinds_for_ft = {
    typescript = {
      "imports",
      "comment",
    },
    vue = {},
  },
}

local lua_ufo = function(ufo_cmd)
  return [[lua require("ufo").]] .. ufo_cmd .. [[()]]
end

return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  event = "VeryLazy",
  opts = opts,
  init = function()
    ufo_u.set_opts()
  end,
  keys = {
    m("zR", lua_ufo("openAllFolds")),
    m("zM", lua_ufo("closeAllFolds")),
    m("zr", lua_ufo("openFoldsExceptKinds")),
    m("zm", lua_ufo("closeFoldsWith")),
    m("]z", lua_ufo("goNextClosedFold")),
    m("[z", lua_ufo("goPreviousClosedFold")),
    m("<leader>O", "UfoToggleFold"),
    m("\\", "FoldParagraph"),
  },
  enabled = true,
}
