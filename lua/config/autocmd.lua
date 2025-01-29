local u = require("util")
local api, bo, opt_local, cmd = vim.api, vim.bo, vim.opt_local, vim.cmd
local augroup, q_to_quit = u.create_augroup, u.map_q_to_quit
local autocmd = api.nvim_create_autocmd
local opt_file_pattern = {
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
  "*.go",
  "Dockerfile",
  "docker-compose.yaml",
}
local cursorline_disable_ft = {
  "help",
  "dashboard",
  "lazy",
  "mason",
  "coderunner",
  "terminal",
}

local all_filetypes = augroup("AllFileTypesLocalOptions")
autocmd({ "FileType" }, {
  group = all_filetypes,
  pattern = { "*" },
  callback = function()
    u.set_formatoptions()
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
    "neotest-output-panel",
    "neotest-summary",
    "neotest-output",
    "dap-view-term",
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
      -- q_to_quit(event)
    end
  end,
})

-- Terminal
local terminal = augroup("TerminalLocalOptions")
autocmd({ "TermOpen" }, {
  group = terminal,
  pattern = { "*" },
  callback = function(evt)
    opt_local.cursorline = false
    local code_term_esc = api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true)
    for _, key in ipairs({ "h", "j", "k", "l" }) do
      vim.keymap.set("t", "<C-" .. key .. ">", function()
        local code_dir = api.nvim_replace_termcodes("<C-" .. key .. ">", true, true, true)
        api.nvim_feedkeys(code_term_esc .. code_dir, "t", true)
      end, { noremap = true, buffer = evt.buf })
    end
    if bo.filetype == "" then
      api.nvim_set_option_value("filetype", "terminal", { buf = evt.buf })
      if vim.g.catgoose_terminal_enable_startinsert == 1 then
        cmd.startinsert()
      end
    end
    if bo.filetype == "dap-view-term" then
      vim.keymap.set("t", "<esc>", function()
        api.nvim_feedkeys(code_term_esc, "t", true)
      end, { noremap = true, buffer = evt.buf })
    end
  end,
})
autocmd({ "WinEnter" }, {
  group = terminal,
  pattern = { "*" },
  callback = function()
    if bo.filetype == "terminal" and vim.g.catgoose_terminal_enable_startinsert then
      cmd.startinsert()
    end
  end,
})

-- Buffer
local buffer = augroup("BufferDetectChanges")
autocmd({ "FocusGained", "BufEnter" }, {
  group = buffer,
  pattern = opt_file_pattern,
  callback = function()
    cmd.checktime()
  end,
})

local cursor_line = augroup("LocalCursorLine")
autocmd({ "WinEnter", "BufWinEnter" }, {
  group = cursor_line,
  pattern = opt_file_pattern,
  callback = function(event)
    if not vim.tbl_contains(cursorline_disable_ft, event.match) then
      opt_local.cursorline = true
    else
      opt_local.cursorline = false
    end
  end,
})
autocmd({ "WinLeave" }, {
  group = cursor_line,
  pattern = opt_file_pattern,
  callback = function()
    opt_local.cursorline = false
  end,
})
autocmd({ "FileType" }, {
  group = cursor_line,
  pattern = { "*" },
  callback = function(event)
    if not vim.tbl_contains(cursorline_disable_ft, event.match) then
      opt_local.cursorline = true
    else
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
