return {
	"jcdickinson/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"jcdickinson/http.nvim",
			build = "cargo build --workspace --release",
		},
	},
	event = "InsertEnter",
	config = true,
}
