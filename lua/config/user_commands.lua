local f = require("util.functions")
local c = require("util").create_cmd

c("BufOnlyWindowOnly", f.buf_only_window_only)
c("CommentYankPaste", f.comment_yank_paste)
c("Help", f.help_select)
c("HelpGrep", f.help_grep)
c("HelpWord", f.help_word)
c("LoadPreviousBuffer", f.load_previous_buffer)
c("ReloadLua", f.reload_lua)
c("SpectreOpen", f.spectre_open)
c("SpectreOpenWord", f.spectre_open_word)
c("SpectreOpenCwd", f.spectre_open_cwd)
c("SpotifyNext", function()
	f.run_system_command({
		cmd = "spt playback -n",
		notify = true,
		notify_config = { title = "Spotify", render = "compact" },
	})
end)
c("SpotifyPrev", function()
	f.run_system_command({
		cmd = "spt playback -p",
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
c("TelescopeFindFilesCwd", f.telescope_find_files_cwd)
c("TelescopeFindFilesNoIgnore", f.telescope_find_files_no_ignore)
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
c("ToggleTermPowershell", function()
	f.toggle_term_cmd({ count = 10, cmd = "pwsh" })
end)
c("ToggleTermRepl", function()
	f.toggle_term_cmd({ count = 8, cmd = { "node", "lua", "irb", "fish", "bash", "python" } })
end)
c("ToggleTermSpotify", function()
	f.toggle_term_cmd({ count = 1, cmd = "spt" })
end)
c("WilderUpdateRemotePlugins", f.wilder_update_remote_plugins)
c("UpdateAndSyncAll", f.update_all)
c("UfoToggleFold", f.ufo_toggle_fold)
c("FoldParagraph", f.fold_paragraph)
c("HoverHandler", require("util").hover_handler)
c("AutoMakeToggle", f.auto_make_toggle)
c("MakeRun", f.make_run)
c("TerminalSendCmd", function()
	f.terminal_send_cmd("ls")
end)
c("OpenTerminalRightScale", function()
	f.terminal_open_split({ direction = "right", scale = 0.25 })
end)
c("OpenTerminalDownScale", function()
	f.terminal_open_split({ direction = "down", scale = 0.25 })
end)
c("OpenTerminalRight", function()
	f.terminal_open_split({ direction = "right" })
end)
c("OpenTerminalDown", function()
	f.terminal_open_split({ direction = "down" })
end)
c("OpenTerminalTab", function()
	f.terminal_open_split({ tab = true })
end)
