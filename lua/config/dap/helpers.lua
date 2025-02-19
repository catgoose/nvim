local M = {}

local port

function M.get_install_path(package)
  return require("mason-registry").get_package(package):get_install_path()
end
function M.get_unused_port(host)
  host = host or "127.0.0.1"
  local server = vim.uv.new_tcp()
  if port then
    local ok = pcall(function()
      server:bind(host, port)
    end)
    if ok then
      server:close()
      return port
    end
  end
  assert(server:bind(host, 0)) -- OS allocates an unused port
  local tcp_t = server:getsockname()
  server:close()
  assert(tcp_t and tcp_t.port > 0, "Failed to get an unused port")
  port = tcp_t.port
  return port
end
function M.create_manual_window()
  local bufnr = vim.api.nvim_create_buf(true, false)
  local winnr = vim.api.nvim_open_win(bufnr, false, {
    split = "below",
    win = -1,
    height = 12,
  })
  return bufnr, winnr
end
function M.get_dap_view_window()
  require("dap-view").open()
  local term_ok, state = pcall(require, "dap-view.state")
  if not term_ok then
    return nil, nil
  end
  local bufnr, winnr = state.term_bufnr, state.term_winnr
  return bufnr, winnr
end
function M.reset_buffer(bufnr)
  -- if nothing to reset
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  if lines and #lines == 1 and lines[1] == "" then
    return
  end
  if not vim.api.nvim_get_option_value("modifiable", { scope = "local", buf = bufnr }) then
    vim.api.nvim_set_option_value("modifiable", true, { scope = "local", buf = bufnr })
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
  vim.api.nvim_set_option_value("modified", false, { scope = "local", buf = bufnr })
end
return M
