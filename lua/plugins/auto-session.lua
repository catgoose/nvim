local opts = {
	log_level = "info",
	auto_session_suppress_dirs = { "~/" },
	auto_restore_enabled = true,
	bypass_session_save_file_types = {
		"neo-tree",
		"dashboard",
	},
}

return {
	"rmagatti/auto-session",
	opts = opts,
	cmd = { "RestoreSession" },
}
