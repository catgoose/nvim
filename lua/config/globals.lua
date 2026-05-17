local g = vim.g

g.catgoose_terminal_enable_startinsert = 1
g.catgoose_supermaven_disabled = true

g.mapleader = " "
g.maplocalleader = ","
g.suda_smart_edit = 1

g.netrw_browse_split = 0
g.netrw_banner = 0
g.netrw_winsize = 25

local x_display = os.getenv("DISPLAY")
if x_display ~= nil and x_display ~= "" then
  g.clipboard = { -- install xclip
    name = "xclip",
    copy = {
      ["+"] = { "sh", "-c", "xclip -f -sel clip | xclip -sel primary" },
      ["*"] = { "sh", "-c", "xclip -f -sel primary | xclip -sel clip" },
    },
    paste = {
      ["+"] = "xclip -o -sel clip",
      ["*"] = "xclip -o -sel primary",
    },
    cache_enabled = 1,
  }
end

-- vim.filetype.add({ extension = { _hs = "hyperscript" } })

-- -- g< to enter pager
-- require("vim._extui").enable({
--   msg = {
--     target = "cmd",
--     timeout = 4000,
--   },
-- })
