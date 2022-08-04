require("config.utils").plugin_setup("auto-session", {
	log_level = "info",
	auto_session_suppress_dirs = { "~/" },
	auto_restore_enabled = false,
	bypass_session_save_file_types = { "neo-tree" },
})
