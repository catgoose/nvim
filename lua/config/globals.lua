local g = vim.g

g.catgoose_terminal_enable_startinsert = 1

g.mapleader = " "
g.maplocalleader = " "
g.suda_smart_edit = 1

g.netrw_browse_split = 0
g.netrw_banner = 0
g.netrw_winsize = 25

local x_display = os.getenv("DISPLAY")
if x_display ~= nil and x_display ~= "" then
  g.clipboard = { -- install xclip
    name = "xclip",
    copy = {
      ["+"] = "xclip -f -sel clip",
      ["*"] = "xclip -f -sel clip",
    },
    paste = {
      ["+"] = "xclip -o -sel clip",
      ["*"] = "xclip -o -sel clip",
    },
    cache_enabled = 1,
  }
end

vim.deprecate = function() end
