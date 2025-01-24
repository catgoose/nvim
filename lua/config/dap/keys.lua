local c = require("util").create_cmd
local f = require("util.functions")

local M = {}
local session_eval = function()
  return require("dap").session() ~= nil
end

function M.setup(dap)
  dap = dap or require("dap")
  local widgets = require("dap.ui.widgets")
  -- user commands
  c("DapClearBreakpoints", function()
    local message = session_eval()
        and string.format("Breakpoints disabled for '%s'", dap.session().config.name)
      or string.format("Breakpoints disabled")
    vim.notify(message, vim.log.levels.INFO)
    dap.clear_breakpoints()
  end)
  c("DapConditionalBreakpoints", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end)
  c("DapReplOpenTab", function()
    f.tab_cb(dap.repl.toggle, session_eval)
  end)
  c("DapScopesOpenTab", function()
    widgets.scopes.new_buf()
  end)
  c("DapScopesVSplit", function()
    if session_eval() then
      widgets.sidebar(widgets.scopes, { width = 50 }).open()
    end
  end)
  c("DapScopesOpenTab", function()
    if session_eval() then
      vim.api.nvim_command("tabnew")
      widgets
        .builder(widgets.scopes)
        .new_buf(function()
          return vim.api.nvim_create_buf(false, true)
        end)
        .new_win(function()
          return vim.api.nvim_get_current_win()
        end)
        .build()
        .open()
    end
  end)
  local win_opts = { border = "rounded" }
  c("DapScopesFloat", function()
    widgets.cursor_float(widgets.scopes, win_opts)
  end)
  c("DapFramesFloat", function()
    widgets.cursor_float(widgets.frames, win_opts)
  end)
  c("DapThreadsFloat", function()
    widgets.cursor_float(widgets.threads, win_opts)
  end)

  vim.keymap.set({ "n", "v" }, "<leader>dP", function()
    require("dap.ui.widgets").preview()
  end)
  -- keybindings
  local function set_km(key, cmd)
    vim.keymap.set("n", "<leader>" .. key, cmd, { noremap = true })
  end
  local keymaps = {
    ds = "DapScopesFloat",
    dS = "DapScopesOpenTab",
    du = "DapFramesFloat",
    dt = "DapThreadsFloat",
    dr = "DapReplOpenTab",
    dj = "DapScopesOpenTab",
    dv = "DapScopesVSplit",
  }
  for key, cmd in pairs(keymaps) do
    set_km(key, "<cmd>" .. cmd .. "<cr>")
  end
end

return M
