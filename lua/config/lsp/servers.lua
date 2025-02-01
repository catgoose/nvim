local M = {}

--- Capabilities
local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)
-- ufo
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
---@diagnostic disable-next-line: inject-field
capabilities.offsetEncoding = { "utf-16" }
-- snippets
local _snippet_capabilities = vim.lsp.protocol.make_client_capabilities()
---@diagnostic disable-next-line: inject-field
_snippet_capabilities.textDocument.completion.completionItem.snippetSupport = true

local snippet_capabilities = vim.tbl_extend("keep", capabilities, _snippet_capabilities)
-- Diagnostic
vim.diagnostic.config({
  virtual_text = false,
  -- virtual_lines = {
  --   only_current_line = true,
  -- },
  -- https://github.com/neovim/neovim/pull/31959
  -- https://github.com/neovim/neovim/pull/32187
  virtual_lines = {
    current_line = true,
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    border = "rounded",
    header = "",
    prefix = "",
  },
})

function M.init(lspconfig)
  if not lspconfig then
    error("lspconfig is required", vim.diagnostic.severity.ERROR)
    return
  end

  local ts_ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
  local vue_ft = { unpack(ts_ft) }
  table.insert(vue_ft, "vue")
  local css_ft = { "css", "scss", "less", "sass", "vue" }
  local tsdk = function()
    return vim.fn.getcwd() .. "/node_modules/typescript/lib"
  end

  local server_enabled = function(server)
    return not require("neoconf").get("lsp.servers." .. server .. ".disable")
  end

  local lspconfig_setups = {
    language_servers = {
      "awk_ls",
      "bashls",
      "docker_compose_language_service",
      "dockerls",
      "golangci_lint_ls",
      "marksman",
      "sqlls",
      "templ",
      "yamlls",
      "azure_pipelines_ls",
    },
    tailwindcss = {
      root_dir = function(fname)
        local root_pattern = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.ts")
        return root_pattern(fname)
      end,
      filetypes = {
        "templ",
        "vue",
        "html",
        "astro",
        "javascript",
        "typescript",
        "react",
        "htmlangular",
      },
    },
    csharp_ls = {
      capabilities = snippet_capabilities,
    },
    cssls = {
      capabilities = snippet_capabilities,
      filetypes = css_ft,
      settings = {
        css = { validate = true, lint = {
          unknownAtRules = "ignore",
        } },
        scss = { validate = true, lint = {
          unknownAtRules = "ignore",
        } },
        less = { validate = true, lint = {
          unknownAtRules = "ignore",
        } },
      },
    },
    html = {
      capabilities = snippet_capabilities,
      filetypes = { "html", "vue", "templ" },
    },
    htmx = {
      filetypes = { "html", "templ" },
    },
    cssmodules_ls = {
      filetypes = vue_ft,
    },
    ts_ls = {
      filetypes = ts_ft,
      init_options = {
        typescript = {
          tsdk = tsdk(),
        },
      },
    },
    volar = {
      filetypes = { "vue" },
      init_options = {
        vue = {
          hybridMode = false,
        },
        typescript = {
          tsdk = tsdk(),
        },
      },
    },
    jsonls = {
      capabilities = snippet_capabilities,
      -- settings = {
      --   json = {
      --     schemas = require("schemastore").json.schemas({
      --       select = {
      --         "package.json",
      --         ".eslintrc",
      --         "tsconfig.json",
      --       },
      --     }),
      --     validate = { enable = true },
      --   },
      -- },
    },
    vimls = {
      diagnostic = { enable = true },
      indexes = {
        count = 3,
        gap = 100,
        projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
        runtimepath = true,
      },
      isNeovim = true,
      iskeyword = "@,48-57,_,192-255,-#",
      runtimepath = "",
      suggest = { fromRuntimepath = true, fromVimruntime = true },
      vimruntime = "",
    },
    lua_ls = {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim", "require" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
          hint = {
            enable = false,
          },
        },
      },
    },
    angularls = {},
    gopls = {
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
          gofumpt = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            -- fieldalignment = true,
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
        },
      },
    },
  }

  local at = require("config.lsp.on_attach")
  local on_attach = at.get()

  for srv, cfg in pairs(lspconfig_setups) do
    if srv == "language_servers" then
      for _, ls in ipairs(cfg) do
        lspconfig[ls].setup({
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end
    elseif server_enabled(srv) then
      if not cfg.on_attach then
        cfg.on_attach = at.get(srv)
      end
      if not cfg.capabilities then
        cfg.capabilities = capabilities
      end
      lspconfig[srv].setup(cfg)
    end
  end

  -- lspconfig.diagnosticls.setup({
  --   capabilities = capabilities,
  --   on_attach = function(client, bufnr)
  --     local stop_ft = {
  --       "dap-repl",
  --     }
  --     for _, ft in pairs(stop_ft) do
  --       if vim.bo.filetype == ft then
  --         if vim.lsp.buf_is_attached(bufnr, client.id) then
  --           local notify = vim.notify
  --           ---@diagnostic disable-next-line: duplicate-set-field
  --           vim.notify = function() end
  --           vim.lsp.buf_detach_client(bufnr, client.id)
  --           vim.notify = notify
  --         end
  --       end
  --     end
  --     on_attach(client, bufnr)
  --   end,
  -- })
end

return M
