local f = require("util.functions")
local u = require("util")
local c = u.create_cmd
local cmd, api, fn, d = vim.cmd, vim.api, vim.fn, vim.diagnostic

c("BufOnlyWindowOnly", function()
  if #api.nvim_list_wins() > 1 then
    cmd.only()
  end
  cmd.BufOnly()
end)
c("WinOnly", function()
  f.win_only()
end)
c("WinOnlyFocusLeft", function()
  f.win_only(function()
    cmd("vsplit")
  end)
end)
c("WinOnlyFocusRight", function()
  f.win_only(function()
    cmd("vsplit")
    cmd.wincmd("h")
  end)
end)
c("WinOnlyFocusDown", function()
  f.win_only(function()
    cmd("split")
    cmd.wincmd("j")
  end)
end)
c("WinOnlyFocusUp", function()
  f.win_only(function()
    cmd("split")
    cmd.wincmd("k")
  end)
end)
c("CommentYankPaste", f.comment_yank_paste)
c("HelpWord", f.help_word)
c("LoadPreviousBuffer", function()
  if #fn.expand("#") > 0 then
    cmd.edit(fn.expand("#"))
  end
end)
c("ReloadLua", u.reload_lua)
c("SpectreOpen", function()
  cmd([[lua require("spectre").open()]])
end)
c("SpectreOpenWord", function()
  cmd([[lua require("spectre").open_visual({select_word = true})]])
end)
c("SpectreOpenCwd", function()
  cmd([[lua require("spectre").open_file_search()]])
end)
c("SpotifyNext", function()
  f.run_system_command({
    cmd = [[spotify_player playback next && spotify_player get key playback | jq -r '.item | "\(.artists | map(.name) | join(", ")) - \(.name)"']],
    notify = true,
    notify_config = { title = "Spotify", render = "compact" },
  })
end)
c("SpotifyPrev", function()
  f.run_system_command({
    cmd = [[spotify_player playback previous && spotify_player get key playback | jq -r '.item | "\(.artists | map(.name) | join(", ")) - \(.name)"']],
    notify = true,
    notify_config = { title = "Spotify", render = "compact" },
  })
end)
c("TagStackDown", function()
  f.tagstack_navigate({ direction = "down" })
end)
c("TagStackUp", function()
  f.tagstack_navigate({ direction = "up" })
end)
c("ToggleCmdHeight", f.toggle_cmdheight)
c("ToggleTermFish", function()
  f.toggle_term_cmd({ count = 4, cmd = "fish" })
end)
c("ToggleTermLazyDocker", function()
  f.toggle_term_cmd({ count = 2, cmd = "lazydocker" })
end)
c("ToggleTermLazyGit", function()
  f.toggle_term_cmd({ count = 3, cmd = "lazygit" })
end)
c("ToggleTermWeeChat", function()
  f.toggle_term_cmd({ count = 5, cmd = "weechat" })
end)
c("ToggleTermPowershell", function()
  f.toggle_term_cmd({ count = 10, cmd = "pwsh" })
end)
c("ToggleTermRepl", function()
  f.toggle_term_cmd({ count = 8, cmd = { "node", "lua", "irb", "fish", "bash", "python" } })
end)
c("ToggleTermSpotify", function()
  f.toggle_term_cmd({ count = 1, cmd = "spotify_player" })
end)
c("UpdateAndSyncAll", function()
  local cmds = {
    "MasonUpdate",
    "MasonToolsUpdate",
    "TSUpdate",
    "Lazy sync",
  }
  for _, cm in ipairs(cmds) do
    cmd(cm)
    print(string.format("Running: %s", cm))
  end
end)
c("UfoToggleFold", require("util.ufo").toggle_fold)
c("FoldParagraph", function()
  local foldclosed = fn.foldclosed(fn.line("."))
  if foldclosed == -1 then
    cmd([[silent! normal! zfip]])
  else
    cmd("silent! normal! zo")
  end
end)
c("HoverHandler", require("util").hover_handler)
c("TerminalSendCmd", function()
  f.terminal_send_cmd("ls")
end)
c("TabNext", function()
  f.tabnavigate({ navto = "next" })
end)
c("TabPrevious", function()
  f.tabnavigate({ navto = "prev" })
end)
c("DisableLSPFormatting", function()
  f.lsp_formatting({ enable = false })
end)
c("EnableLSPFormatting", function()
  f.lsp_formatting({ enable = true })
end)
c("PersistenceLoad", function()
  require("persistence").load()
end)
c("DiffviewPrompt", require("util.diffview").open)
c("DiagnosticsJumpPrev", function()
  f.diagnostics_jump({
    count = -1,
    float = true,
  })
end)
c("DiagnosticsJumpNext", function()
  f.diagnostics_jump({
    count = 1,
    float = true,
  })
end)
c("DiagnosticsErrorJumpPrev", function()
  f.diagnostics_jump({
    count = -1,
    severity = d.severity.ERROR,
    float = true,
  })
end)
c("DiagnosticsErrorJumpNext", function()
  f.diagnostics_jump({
    count = 1,
    severity = d.severity.ERROR,
    float = true,
  })
end)
c("QuickFixClear", function()
  vim.fn.setqflist({}, "r")
end)
c("TermOpenTab", function()
  f.tab_open("tab term")
end)
c("TermOpenBottom", function()
  f.tab_open("botright term")
end)
c("TermOpenBottomVert", function()
  f.tab_open("horizontal term")
end)
c("TermOpenRight", function()
  f.tab_open("vertical term")
end)

c("TestingFunction", f.testing_function)
