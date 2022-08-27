local g = require("config.utils").set_global

g("Hexokinase_highlighters", { "background", "virtual" })
g("Hexokinase_optInPatterns", { "full_hex,triple_hex, rgb, rgba, hsl, hsla, colour_names" })
g("Hexokinase_ftEnabled", { "css", "scss", "sass", "html", "javascript", "toml", "i3config", "roficonfig", "lua" })
g("Hexokinase_ftOptInPatterns", {
	i3config = "full_hex,triple_hex",
	roficonfig = "full_hex,triple_hex",
	css = "full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names",
	scss = "full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names",
	sass = "full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names",
	html = "full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names",
	lua = "full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names",
	toml = "full_hex,triple_hex",
})
