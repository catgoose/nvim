local km, l, api = vim.keymap.set, vim.lsp, vim.api
local h, p = l.handlers, l.protocol

local config = function()
  local lspconfig = require("lspconfig")
  local vt = require("virtualtypes")

  --- Capabilities
  local capabilities = vim.tbl_deep_extend(
    "force",
    l.protocol.make_client_capabilities(),
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
  local _snippet_capabilities = p.make_client_capabilities()
  ---@diagnostic disable-next-line: inject-field
  _snippet_capabilities.textDocument.completion.completionItem.snippetSupport = true
  local snippet_capabilities = vim.tbl_extend("keep", capabilities, _snippet_capabilities)
  -- Diagnostic
  vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = {
      only_current_line = true,
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

  -- handler overrides
  l.handlers["textDocument/hover"] = function(_, result, ctx, config)
    if not (result and result.contents) then
      return
    end
    config = config or {}
    config.border = "rounded"
    h.hover(_, result, ctx, config)
  end
  h["textDocument/signatureHelp"] = l.with(h.signature_help, {
    border = "rounded",
  })
  h["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
    local ts_lsp = { "tsserver", "angularls", "volar" }
    local clients = l.get_clients({ id = ctx.client_id })
    if vim.tbl_contains(ts_lsp, clients[1].name) then
      local filtered_result = {
        diagnostics = vim.tbl_filter(function(d)
          return d.severity == 1
        end, result.diagnostics),
      }
      require("ts-error-translator").translate_diagnostics(err, filtered_result, ctx, config)
    end
    l.diagnostic.on_publish_diagnostics(err, result, ctx, config)
  end
  -- local inlay_hint_handler = h[p.Methods["textDocument_inlayHint"]]
  -- h[p.Methods["textDocument_inlayHint"]] = function(err, result, ctx, config)
  --   local client = l.get_client_by_id(ctx.client_id)
  --   if not result then
  --     result = {}
  --   end
  --   if client then
  --     local row = unpack(vim.api.nvim_win_get_cursor(0))
  --     result = vim
  --       .iter(result)
  --       :filter(function(hint)
  --         -- return math.abs(hint.position.line - row) <= 5
  --         return hint.position.line + 1 == row
  --       end)
  --       :totable()
  --   end
  --   inlay_hint_handler(err, result, ctx, config)
  -- end

  -- local function inlay_hints_autocmd(bufnr)
  --   local inlay_hints_group = vim.api.nvim_create_augroup("LSP_inlayHints", { clear = false })
  --   vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  --     group = inlay_hints_group,
  --     desc = "Update inlay hints on line change",
  --     buffer = bufnr,
  --     callback = function()
  --       l.inlay_hint.enable(true, { bufnr = bufnr })
  --     end,
  --   })
  -- end
  -- on_attach definitions
  local function inlay_hints_on_attach(client, bufnr)
    local inlay_lsp = {
      "gopls",
    }
    if vim.tbl_contains(inlay_lsp, client.name) then
      -- l.inlay_hint.enable()
      -- inlay_hints_autocmd(bufnr)
    end
  end
  local function virtual_types_on_attach(client, bufnr)
    if client.server_capabilities.textDocument then
      if client.server_capabilities.textDocument.codeLens then
        vt.on_attach(client, bufnr)
      end
    end
  end
  local function on_attach(client, bufnr)
    virtual_types_on_attach(client, bufnr)
    inlay_hints_on_attach(client, bufnr)
  end
  local function go_on_attach(client, bufnr)
    if not client.server_capabilities.semanticTokensProvider then
      local semantic = client.config.capabilities.textDocument.semanticTokens
      client.server_capabilities.semanticTokensProvider = {
        full = true,
        legend = {
          tokenTypes = semantic.tokenTypes,
          tokenModifiers = semantic.tokenModifiers,
        },
        range = true,
      }
    end
    on_attach(client, bufnr)
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(event)
      local bufopts = { noremap = true, silent = true, buffer = event.buf }
      km("n", "[g", function()
        vim.cmd("DiagnosticsErrorJumpPrev")
      end, bufopts)
      km("n", "]g", function()
        vim.cmd("DiagnosticsErrorJumpNext")
      end, bufopts)
      km("n", "[G", function()
        vim.cmd("DiagnosticsJumpPrev")
      end, bufopts)
      km("n", "]G", function()
        vim.cmd("DiagnosticsJumpNext")
      end, bufopts)
      km("n", "<leader>dd", vim.diagnostic.setqflist, bufopts)
      km("n", "gD", l.buf.declaration, bufopts)
      if not require("neoconf").get("lsp.keys.goto_definition.disable") then
        km("n", "gd", l.buf.definition, bufopts)
      end
      km("n", "gi", l.buf.implementation, bufopts)
      km("n", "<leader>D", l.buf.type_definition, bufopts)
      km("n", "gr", l.buf.references, bufopts)
      km({ "n", "v" }, "<leader>ca", l.buf.code_action, bufopts)
      km("n", "<leader>rn", l.buf.rename, bufopts)
      km("n", "L", l.buf.hover, bufopts)
      km("n", "<leader>di", function()
        local enabled = l.inlay_hint.is_enabled({ bufnr = event.buf })
        -- if enabled then
        -- vim.api.nvim_create_augroup("LSP_inlayHints", { clear = true })
        -- else
        --   inlay_hints_autocmd(event.buf)
        -- end
        l.inlay_hint.enable(not enabled, { bufnr = event.buf })
        require("notify").notify(
          string.format(
            "Inlay hints %s for buffer %d",
            not enabled and "enabled" or "disabled",
            event.buf
          ),
          vim.log.levels.info,
          ---@diagnostic disable-next-line: missing-fields
          {
            title = "LSP inlay hints",
          }
        )
      end, bufopts)
      km("n", "<leader>dI", function()
        local enabled = l.inlay_hint.is_enabled({ bufnr = event.buf })
        l.inlay_hint.enable(not enabled)
        require("notify").notify(
          string.format("Inlay hints %s globally", not enabled and "enabled" or "disabled"),
          vim.log.levels.info,
          ---@diagnostic disable-next-line: missing-fields
          {
            title = "LSP inlay hints",
          }
        )
      end, { noremap = bufopts.noremap, silent = bufopts.silent })
    end,
  })

  -- LSP config
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
      "yamlls",
    },
    tailwindcss = {
      root_dir = function(fname)
        local root_pattern = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.ts")
        return root_pattern(fname)
      end,
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
      filetypes = { "html", "vue" },
    },
    cssmodules_ls = {
      filetypes = vue_ft,
    },
    tsserver = {
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
      settings = {
        json = {
          schemas = require("schemastore").json.schemas({
            select = {
              "package.json",
              ".eslintrc",
              "tsconfig.json",
            },
          }),
          validate = { enable = true },
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
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim", "require" },
          },
          workspace = {
            library = api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
          hint = {
            enable = true,
          },
        },
      },
    },
    angularls = {
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        client.server_capabilities.renameProvider = false
      end,
    },
    gopls = {
      on_attach = go_on_attach,
      settings = {
        gopls = {
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
            fieldalignment = true,
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
        },
      },
    },
  }

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
        cfg.on_attach = on_attach
      end
      if not cfg.capabilities then
        cfg.capabilities = capabilities
      end
      lspconfig[srv].setup(cfg)
    end
  end

  if server_enabled("diagnosticls") then
    lspconfig.diagnosticls.setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        local stop_ft = {
          "dap-repl",
        }
        for _, ft in pairs(stop_ft) do
          if vim.bo.filetype == ft then
            if l.buf_is_attached(bufnr, client.id) then
              local notify = vim.notify
              ---@diagnostic disable-next-line: duplicate-set-field
              vim.notify = function() end
              l.buf_detach_client(bufnr, client.id)
              vim.notify = notify
            end
          end
        end
        on_attach(client, bufnr)
      end,
    })
  end
end

return {
  "neovim/nvim-lspconfig",
  init = function()
    require("neoconf").setup({})
  end,
  config = config,
  dependencies = {
    "windwp/nvim-autopairs",
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = "williamboman/mason.nvim",
    },
    "b0o/schemastore.nvim",
    "litao91/lsp_lines",
    "kevinhwang91/nvim-ufo",
    "VidocqH/lsp-lens.nvim",
    "jubnzv/virtual-types.nvim",
    "folke/neoconf.nvim",
    {
      "dmmulroy/ts-error-translator.nvim",
      config = true,
      ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
    },
    {
      -- "chrisgrieser/nvim-lsp-endhints",
      dir = "~/git/nvim-lsp-endhints",
      event = "LspAttach",
      opts = {
        icons = {
          type = "󰋙 ",
          parameter = " ",
        },
        label = {
          padding = 1,
          marginLeft = 0,
          bracketedParameters = false,
        },
        autoEnableHints = true,
      },
    },
  },
}
