local opts = {
	log_level = "error",
	auto_session_suppress_dirs = { "~/" },
	auto_restore_enabled = false,
	auto_session_enabled = true,
	bypass_session_save_file_types = {
		"dashboard",
	},
}

return {
	"rmagatti/auto-session",
	lazy = false,
	opts = opts,
	cmd = { "SessionRestore" },
}
