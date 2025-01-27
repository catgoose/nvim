vim.keymap.set("n", "<c-w>", function()
  local oil = require("oil")
  local entry = oil.get_cursor_entry()
  if not entry or entry.type ~= "file" then
    return
  end
  local dir = oil.get_current_dir()
  oil.close({ exit_if_last_buf = false })
  local winnr = require("window-picker").pick_window({
    filter_rules = {
      autoselect_one = true,
      include_current_win = true,
    },
  })
  if winnr then
    vim.api.nvim_set_current_win(winnr)
    local path = vim.fs.joinpath(dir, entry.name)
    vim.cmd.edit(path)
  end
end, {
  buffer = true,
  nowait = true,
})
