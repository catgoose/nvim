local M = {}

--- Capabilities
local capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)
-- -@diagnostic disable-next-line: inject-field
-- capabilities.offsetEncoding = { "utf-16" }
-- snippets
-- local _snippet_capabilities = vim.lsp.protocol.make_client_capabilities()
-- _snippet_capabilities.textDocument.completion.completionItem.snippetSupport = true

-- local snippet_capabilities = vim.tbl_extend("keep", capabilities, _snippet_capabilities)
-- Diagnostic

function M.init()
  local ts_ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
  local css_ft = { "css", "scss", "less", "sass" }
  local tsdk = function()
    return vim.fn.getcwd() .. "/node_modules/typescript/lib"
  end

  local servers = {
    no_cfg_ls = {
      -- "angularls",
      "azure_pipelines_ls",
      "bashls",
      "diagnosticls",
      "docker_compose_language_service",
      "dockerls",
      "jsonls",
      "marksman",
      "sqlls",
      "templ",
      "yamlls",
    },
    tailwindcss = {
      filetypes = {
        "templ",
        "html",
        "astro",
        "javascript",
        "typescript",
        "react",
        "htmlangular",
      },
    },
    cssls = {
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
      filetypes = { "html", "templ" },
    },
    -- htmx = {
    --   filetypes = { "html", "templ" },
    -- },
    cssmodules_ls = {
      filetypes = ts_ft,
    },
    angularls = {},
    ts_ls = {
      filetypes = ts_ft,
      init_options = {
        typescript = {
          tsdk = tsdk(),
        },
      },
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
          },
        },
      },
    },
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
        vim.lsp.enable(ls)
      end
    else
      cfg.on_attach = cfg.on_attach or at.get(srv)
      cfg.capabilities = cfg.capabilities or capabilities
      vim.lsp.config(srv, cfg)
      vim.lsp.enable(srv)
    end
  end
end

return M
