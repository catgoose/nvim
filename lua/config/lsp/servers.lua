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

function M.init()
  local ts_ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
  local vue_ft = { unpack(ts_ft) }
  table.insert(vue_ft, "vue")
  local css_ft = { "css", "scss", "less", "sass", "vue" }
  local tsdk = function()
    return vim.fn.getcwd() .. "/node_modules/typescript/lib"
  end

  -- local server_enabled = function(server)
  --   return not require("neoconf").get("lsp.servers." .. server .. ".disable")
  -- end

  local servers = {
    no_cfg_ls = {
      "awk_ls",
      "bashls",
      "docker_compose_language_service",
      "dockerls",
      -- "golangci_lint_ls",
      "marksman",
      "sqlls",
      "templ",
      "yamlls",
      "azure_pipelines_ls",
      "diagnosticls",
      "lua_ls",
    },
    tailwindcss = {
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
        css = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
        scss = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
        less = {
          validate = true,
          lint = {
            unknownAtRules = "ignore",
          },
        },
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
    jsonls = {
      capabilities = snippet_capabilities,
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
    -- lua_ls = {
    --   settings = {
    --     Lua = {
    --       runtime = {
    --         version = "LuaJIT",
    --       },
    --       diagnostics = {
    --         globals = { "vim", "require" },
    --       },
    --       workspace = {
    --         library = vim.api.nvim_get_runtime_file("", true),
    --         checkThirdParty = false,
    --       },
    --       telemetry = { enable = false },
    --       hint = {
    --         enable = false,
    --       },
    --     },
    --   },
    -- },
    -- angularls = {},
    gopls = {
      settings = {
        gopls = {
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
          buildFlags = { "-tags=mage" },
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

  for srv, cfg in pairs(servers) do
    if srv == "no_cfg_ls" then
      for _, ls in ipairs(cfg) do
        vim.lsp.config(ls, {
          capabilities = capabilities,
          on_attach = at.get(ls),
        })
      end
    end
    cfg.on_attach = cfg.on_attach or at.get(srv)
    cfg.capabilities = cfg.capabilities or capabilities
    vim.lsp.config(srv, cfg)
  end
end

return M
