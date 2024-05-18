local u = require("util")
local api, bo, opt_local, cmd = vim.api, vim.bo, vim.opt_local, vim.cmd
local augroup, q_to_quit = u.create_augroup, u.map_q_to_quit
local autocmd = api.nvim_create_autocmd
local file_pattern = {
  "*.cpp",
  "*.css",
  "*.fish",
  "*.html",
  "*.json",
  "*.lua",
  "*.md",
  "*.rb",
  "*.sass",
  "*.scss",
  "*.sh",
  "*.ts",
  "*.vue",
  "Dockerfile",
  "docker-compose.yaml",
}

local all_filetypes = augroup("AllFileTypesLocalOptions")
autocmd({ "FileType" }, {
  group = all_filetypes,
  pattern = { "*" },
  callback = function()
    --  TODO: 2024-05-18 - move this to common location, used in
    --  ftplugin/neogitcommitmessage
    opt_local.formatoptions = opt_local.formatoptions
      - "t"
      + "c"
      - "r"
      - "o"
      - "q"
      - "a"
      + "n"
      - "2"
      + "l"
      + "j"
  end,
})
autocmd({ "FileType" }, {
  group = all_filetypes,
  pattern = { "*" },
  callback = function()
    u.restore_cmdheight()
  end,
})

-- Q to quit
local quit = augroup("FtQToQuit")
autocmd({ "FileType" }, {
  group = quit,
  pattern = {
    "copilot.*",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "tsplayground",
    "octo",
    "ClangdAST",
    "ClangdTypeHierarchy",
    "dap-repl",
    "dapui_watches",
    "dapui_stacks",
    "dapui_breakpoints",
    "dapui_scopes",
    "dapui_console",
    "netrw",
    "dbout",
  },
  callback = function(event)
    q_to_quit(event)
  end,
})
autocmd({ "FileType" }, {
  group = quit,
  pattern = { "*" },
  callback = function(event)
    if bo.buftype == "nofile" then
      q_to_quit(event)
    end
  end,
})
autocmd({ "BufEnter" }, {
  group = quit,
  pattern = { "*" },
  callback = function(event)
    if bo.buftype == "" and bo.filetype == "" then
      q_to_quit(event)
    end
  end,
})

-- Terminal
local terminal = augroup("TerminalLocalOptions")
autocmd({ "TermOpen" }, {
  group = terminal,
  pattern = { "*" },
  callback = function(event)
    opt_local.number = false
    opt_local.relativenumber = false
    opt_local.cursorline = false
    opt_local.signcolumn = "no"
    opt_local.statuscolumn = ""
    local code_term_esc = api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true)
    for _, key in ipairs({ "h", "j", "k", "l" }) do
      vim.keymap.set("t", "<C-" .. key .. ">", function()
        local code_dir = api.nvim_replace_termcodes("<C-" .. key .. ">", true, true, true)
        api.nvim_feedkeys(code_term_esc .. code_dir, "t", true)
      end, { noremap = true })
    end
    if bo.filetype == "" then
      api.nvim_set_option_value("filetype", "terminal", { buf = event.bufnr })
      cmd.startinsert()
    end
  end,
})
autocmd({ "WinEnter" }, {
  group = terminal,
  pattern = { "*" },
  callback = function()
    if bo.filetype == "terminal" then
      cmd.startinsert()
    end
  end,
})

--  TODO: 2024-04-12 - Can this be moved to a ftplugin file?
local dashboard = augroup("DashboardWinhighlight")
autocmd({ "FileType" }, {
  group = dashboard,
  pattern = { "dashboard" },
  callback = function()
    vim.wo.winhighlight = "NormalNC:Normal"
    autocmd({ "BufReadPre" }, {
      group = dashboard,
      pattern = { "*" },
      callback = function()
        vim.wo.winhighlight = ""
        augroup("DashboardWinhighlight")
      end,
    })
  end,
})

-- Buffer
local buffer = augroup("BufferDetectChanges")
autocmd({ "FocusGained", "BufEnter" }, {
  group = buffer,
  pattern = file_pattern,
  callback = function()
    cmd.checktime()
  end,
})

local cursor_line = augroup("LocalCursorLine")
autocmd({ "WinEnter", "BufWinEnter" }, {
  group = cursor_line,
  pattern = file_pattern,
  callback = function()
    if bo.filetype ~= "nofile" then
      opt_local.cursorline = true
    end
  end,
})
autocmd({ "WinLeave" }, {
  group = cursor_line,
  pattern = file_pattern,
  callback = function()
    if bo.filetype ~= "nofile" then
      opt_local.cursorline = false
    end
  end,
})

-- Lua reload
local write_source = augroup("ConfigWritePostReload")
autocmd({ "BufWritePost" }, {
  group = write_source,
  pattern = {
    "*/nvim/lua/config/*.lua",
    "*/nvim/lua/util/*.lua",
  },
  callback = function()
    if not u.diag_error() then
      u.reload_lua()
    end
  end,
})
