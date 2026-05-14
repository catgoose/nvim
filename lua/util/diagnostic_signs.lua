local severity = vim.diagnostic.severity

local M = {
  hl = {
    error = "DiagnosticSignError",
    warn = "DiagnosticSignWarn",
    hint = "DiagnosticSignHint",
    info = "DiagnosticSignInfo",
  },
  icons = {
    error = "",
    warn = "",
    hint = "",
    info = "",
  },
}

M.by_severity = {
  [severity.ERROR] = {
    name = M.hl.error,
    icon = M.icons.error,
  },
  [severity.WARN] = {
    name = M.hl.warn,
    icon = M.icons.warn,
  },
  [severity.HINT] = {
    name = M.hl.hint,
    icon = M.icons.hint,
  },
  [severity.INFO] = {
    name = M.hl.info,
    icon = M.icons.info,
  },
}

function M.icon(level, opts)
  local sign = M.by_severity[level]
  if not sign then
    return ""
  end

  if opts and opts.pad then
    return sign.icon .. " "
  end

  return sign.icon
end

function M.sign_name(level)
  local sign = M.by_severity[level]
  return sign and sign.name or nil
end

function M.sign_text()
  local signs = {}
  for level, sign in pairs(M.by_severity) do
    signs[level] = sign.icon
  end
  return signs
end

function M.legacy_signs()
  return {
    { name = M.hl.error, dict = { text = M.icons.error, texthl = M.hl.error } },
    { name = M.hl.warn, dict = { text = M.icons.warn, texthl = M.hl.warn } },
    { name = M.hl.hint, dict = { text = M.icons.hint, texthl = M.hl.hint } },
    { name = M.hl.info, dict = { text = M.icons.info, texthl = M.hl.info } },
  }
end

return M
