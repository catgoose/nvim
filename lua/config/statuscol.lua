local M = {}
_G.Status = M
M.ffi = require("ffi")

M.ffi.cdef([[
	typedef struct {} Error;
	typedef struct {} win_T;
	typedef struct {
		int start;  // line number where deepest fold starts
		int level;  // fold level, when zero other fields are N/A
		int llevel; // lowest level that starts in v:lnum
		int lines;  // number of lines from v:lnum to end of closed fold
	} foldinfo_T;
	foldinfo_T fold_info(win_T* wp, int lnum);
	win_T *find_window_by_handle(int Window, Error *err);
]])

function M.get_signs()
  local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  return vim.tbl_map(function(sign)
    return vim.fn.sign_getdefined(sign.name)[1]
  end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
end

function M.fold_col()
  local Cfold_info = M.ffi.C.fold_info
  local wp = M.ffi.C.find_window_by_handle(vim.g.statusline_winid, M.ffi.new("Error"))
  local foldinfo = Cfold_info(wp, vim.v.lnum)
  if foldinfo.start == vim.v.lnum then
    if vim.fn.foldclosed(vim.v.lnum) ~= -1 then
      return [[%#StatusColumnFoldClosed#]] .. [[▶]] .. [[%*]]
    end
  end
  return ""
end

function M.sign_col()
  local sign, git_sign

  for _, s in ipairs(M.get_signs()) do
    if s.name:find("GitSign") then
      git_sign = s
    else
      sign = s
    end
  end

  return {
    sign = sign and ("%#" .. sign.texthl .. "#" .. sign.text .. "%*") or "",
    git_sign = git_sign and ("%#" .. git_sign.texthl .. "#" .. git_sign.text .. "%*") or "  ",
  }
end

function M.column()
  local fold = M.fold_col()
  local signs = M.sign_col()
  local nu = ""
  local number = vim.api.nvim_win_get_option_value(vim.g.statusline_winid, "number")
  if number and vim.wo.relativenumber and vim.v.virtnum == 0 then
    ---@diagnostic disable-next-line: cast-local-type
    nu = vim.v.relnum == 0 and vim.v.lnum or vim.v.relnum
  end

  local cols = {
    fold,
    signs.sign,
    [[%=]],
    nu,
    " " .. signs.git_sign,
  }
  return table.concat(cols, "")
end

if vim.fn.has("nvim-0.9.0") == 1 then
  vim.opt.statuscolumn = [[%!v:lua.Status.column()]]
end

return M
