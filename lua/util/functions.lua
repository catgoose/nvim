local fn, cmd, api, o, g, ui = vim.fn, vim.cmd, vim.api, vim.o, vim.g, vim.ui
local set_cur = api.nvim_win_set_cursor
local t = require("util.toggle")
local u = require("util")

local M = {}

function M.comment_yank_paste()
  local win = api.nvim_get_current_win()
  local cur = api.nvim_win_get_cursor(win)
  local vstart = fn.getpos("v")[2]
  local current_line = fn.line(".")
  if vstart == current_line then
    cmd.yank()
    require("Comment.api").toggle.linewise.current()
    cmd.put()
    set_cur(win, { cur[1] + 1, cur[2] })
  else
    if vstart < current_line then
      cmd(":" .. vstart .. "," .. current_line .. "y")
      cmd.put()
      set_cur(win, { fn.line("."), cur[2] })
    else
      cmd(":" .. current_line .. "," .. vstart .. "y")
      set_cur(win, { vstart, cur[2] })
      cmd.put()
      set_cur(win, { fn.line("."), cur[2] })
    end
    require("Comment.api").toggle.linewise(fn.visualmode())
  end
end

function M.win_only(cb)
  cb = cb or nil
  if #api.nvim_list_wins() > 1 then
    cmd.only()
  end
  if cb then
    cb()
  end
end

function M.toggle_cmdheight()
  if o.cmdheight == 1 then
    o.cmdheight = 0
    ---@diagnostic disable-next-line: inject-field
    g.CMDHEIGHTZERO = 1
  else
    o.cmdheight = 1
    ---@diagnostic disable-next-line: inject-field
    g.CMDHEIGHTZERO = 0
  end
end

function M.toggle_term_cmd(config)
  if not config or not config.count then
    return
  end
  if config.cmd[1] ~= nil then
    ui.select(config.cmd, {
      prompt = "Select command",
    }, function(selected)
      if not selected then
        return
      end
      config.cmd = selected
      M.toggle_term_cmd(config)
    end)
  else
    local term_config = t.toggleterm_opts(config)
    local Terminal = require("toggleterm.terminal").Terminal
    local term = Terminal:new(term_config)
    term:toggle()
  end
end

function M.run_system_command(config)
  if not config or not config.cmd then
    return
  end
  config.notify_config = config.notify_config or { title = "System Command" }
  vim.defer_fn(function()
    local handle = io.popen(config.cmd)
    if handle then
      local result = handle:read("*a")
      handle:close()
      if config.notify == true then
        require("notify").notify(result, vim.log.levels.INFO, config.notify_config)
      end
    end
  end, 0)
end

function M.tab_cb(cb, eval)
  if not cb then
    return
  end
  if eval and type(eval) == "function" and not eval() then
    return
  end
  if type(cb) == "function" then
    vim.cmd.tabnew()
    local winnr = api.nvim_get_current_win()
    cb()
    api.nvim_win_close(winnr, false)
  end
end

local function open_help_tab(help_cmd, topic)
  cmd.tabe()
  local winnr = api.nvim_get_current_win()
  cmd("silent! " .. help_cmd .. " " .. topic)
  api.nvim_win_close(winnr, false)
end

function M.help_word()
  local current_word = u.current_word()
  open_help_tab("help", current_word)
end

function M.tagstack_navigate(config)
  if not config or not config.direction then
    return
  end
  local direction = config.direction
  local tagstack = fn.gettagstack()
  if tagstack == nil or tagstack.items == nil or #tagstack.items == 0 then
    return
  end
  if direction == "up" then
    if tagstack.curidx > tagstack.length then
      return
    end
    cmd.tag()
  end
  if direction == "down" then
    if tagstack.curidx == 1 then
      return
    end
    cmd.pop()
  end
end

function M.terminal_send_cmd(cmd_text)
  local function get_first_terminal()
    local terminal_chans = {}
    for _, chan in pairs(api.nvim_list_chans()) do
      if chan["mode"] == "terminal" and chan["pty"] ~= "" then
        table.insert(terminal_chans, chan)
      end
    end
    table.sort(terminal_chans, function(left, right)
      return left["buffer"] < right["buffer"]
    end)
    if #terminal_chans == 0 then
      return nil
    end
    return terminal_chans[1]["id"]
  end

  local send_to_terminal = function(terminal_chan, term_cmd_text)
    api.nvim_chan_send(terminal_chan, term_cmd_text .. "\n")
  end

  local terminal = get_first_terminal()
  if not terminal then
    return nil
  end

  if not cmd_text then
    ui.input({ prompt = "Send to terminal: " }, function(input_cmd_text)
      if not input_cmd_text then
        return nil
      end
      send_to_terminal(terminal, input_cmd_text)
    end)
  else
    send_to_terminal(terminal, cmd_text)
  end
  return true
end

function M.tabnavigate(cfg)
  cfg = cfg or {
    navto = "next",
  }
  if cfg.navto ~= "next" and cfg.navto ~= "prev" then
    return
  end
  local nav = cfg.navto == "next" and cmd.tabnext or cmd.tabprev
  local term_escape = api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true)
  if vim.bo.filetype == "terminal" then
    api.nvim_feedkeys(term_escape, "t", true)
  end
  nav()
end

function M.diagnostics_jump(config)
  local sev = vim.diagnostic.severity
  config = config or {}
  config.count = config.count or 1
  if config.count == 0 then
    return
  end
  config.float = config.float or false
  config.severity = config.severity or sev.ERROR
  config.scan_direction = config.scan_direction or -1
  local get = config.count > 0 and vim.diagnostic.get_next or vim.diagnostic.get_prev
  local diag = get({
    count = config.count,
    severity = config.severity,
  })
  if diag then
    vim.diagnostic.jump({
      count = config.count,
      severity = config.severity,
      float = config.float,
    })
  else
    if
      (config.severity == sev.ERROR and config.scan_direction == -1)
      or (config.severity == sev.HINT and config.scan_direction == 1)
    then
      return
    end
    config.severity = config.severity + config.scan_direction
    M.diagnostics_jump(config)
  end
end

function M.term_open(c)
  vim.g.catgoose_terminal_enable_startinsert = 1
  if type(c) == "string" then
    cmd(c)
  end
  if type(c) == "table" then
    for _, v in ipairs(c) do
      cmd(v)
    end
  end
end

function M.testing_function()
  local get_text = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
    local query_string = [[
    (method_declaration
      receiver: (parameter_list 
        (parameter_declaration) @receiver_param)
      name: (field_identifier) @method_name)
  ]]
    -- Parse the query
    local lang = vim.treesitter.language.get_lang("go")
    if not lang then
      return
    end
    local query = vim.treesitter.query.parse(lang, query_string)
    -- Get the root of the syntax tree
    local parser = vim.treesitter.get_parser(bufnr, "go")
    if not parser then
      return
    end
    local tree = parser:parse()[1]
    local root = tree:root()
    local best_match = nil
    local best_row = 0
    for _, match, _ in query:iter_matches(root, bufnr, 0, cursor_row) do
      for id, nodes in pairs(match) do
        local name = query.captures[id]
        if name == "receiver_param" then
          for _, node in ipairs(nodes) do
            local start_row = node:range() -- Get start position
            if start_row < cursor_row and start_row > best_row then
              local text = vim.treesitter.get_node_text(node, bufnr)
              if text ~= nil then
                best_match = node
                best_row = start_row
              end
            end
          end
        end
      end
    end
    -- If we found a match, return its text
    if best_match then
      local receiver_text = vim.treesitter.get_node_text(best_match, bufnr)
      return receiver_text
    end
    return
  end
  local res = get_text()
  vim.print(string.format("res: %s", vim.inspect(res)))
end

function M.make_open_qf()
  vim.print(
    string.format(
      "Compiling with '%s'",
      vim.api.nvim_get_option_value("makeprg", { scope = "local" })
    )
  )
  cmd("silent! make")
  if #vim.fn.getqflist() > 0 then
    cmd.copen()
  else
    vim.print("Compiling complete with no errors!")
  end
end

return M
