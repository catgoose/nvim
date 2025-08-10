local lspconfig = require("lspconfig")
require("config.lsp.handlers").init()
require("config.lsp.autocmd").lsp_attach()
require("config.lsp.servers").init(lspconfig)
