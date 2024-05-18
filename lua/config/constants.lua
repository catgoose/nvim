local M = {}

M.const = {
  opt = {
    sessionoptions = "buffers,curdir,folds,help,winsize,winpos,tabpages,terminal,localoptions",
  },
}

M.const.opt.sessionoptions_tbl = vim.split(M.const.opt.sessionoptions, ",")

return M
