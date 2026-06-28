local M = {}

local function inlay_hints_autocmd(bufnr)
  local inlay_hints_group = vim.api.nvim_create_augroup("LSP_inlayHints", { clear = false })
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = inlay_hints_group,
    buffer = bufnr,
    callback = function()
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end,
  })
  vim.api.nvim_create_autocmd("InsertEnter", {
    group = inlay_hints_group,
    buffer = bufnr,
    callback = function()
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end,
  })
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = inlay_hints_group,
    buffer = bufnr,
    callback = function()
      vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
    end,
  })
end

function M.inlay_hints()
  return inlay_hints_autocmd
end

local function set_lsp_keymaps(bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "[g", function()
    vim.cmd("DiagnosticsErrorJumpPrev")
  end, bufopts)
  vim.keymap.set("n", "]g", function()
    vim.cmd("DiagnosticsErrorJumpNext")
  end, bufopts)
  vim.keymap.set("n", "[G", function()
    vim.cmd("DiagnosticsJumpPrev")
  end, bufopts)
  vim.keymap.set("n", "]G", function()
    vim.cmd("DiagnosticsJumpNext")
  end, bufopts)

  vim.keymap.set("n", "<leader>dd", vim.diagnostic.setqflist, bufopts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)

  vim.keymap.set("n", "L", function()
    vim.lsp.buf.hover({ border = "rounded" })
  end, bufopts)
  vim.keymap.set("n", "<leader>di", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
    if enabled then
      vim.api.nvim_create_augroup("LSP_inlayHints", { clear = true })
    else
      M.inlay_hints()(bufnr)
    end
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
    require("notify").notify(
      string.format(
        "Inlay hints %s for buffer %d",
        not enabled and "enabled" or "disabled",
        bufnr
      ),
      vim.log.levels.INFO,
      ---@diagnostic disable-next-line: missing-fields
      {
        title = "LSP inlay hints",
      }
    )
  end, bufopts)
end

function M.init()
  -- Disable Neovim's built-in LSP document color highlighting (enabled by default).
  -- Colorizer handles all color highlighting instead.
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      if vim.lsp.document_color then
        vim.lsp.document_color.enable(false, args.buf)
      end
    end,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(event)
      set_lsp_keymaps(event.buf)
      vim.keymap.set("n", "<leader>dI", function()
        local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
        vim.lsp.inlay_hint.enable(not enabled)
        require("notify").notify(
          string.format("Inlay hints %s globally", not enabled and "enabled" or "disabled"),
          vim.log.levels.INFO,
          ---@diagnostic disable-next-line: missing-fields
          {
            title = "LSP inlay hints",
          }
        )
      end, { noremap = true, silent = true })
    end,
  })

  for _, client in ipairs(vim.lsp.get_clients()) do
    for bufnr in pairs(client.attached_buffers or {}) do
      set_lsp_keymaps(bufnr)
    end
  end
end

return M
