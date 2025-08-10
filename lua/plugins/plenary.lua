local config = function()
  local reload = require("plenary.reload")
  local reloader = reload.reload_module

  P = function(...)
    local tbl = {}
    for i = 1, select("#", ...) do
      local v = select(i, ...)
      table.insert(tbl, vim.inspect(v))
    end

    print(table.concat(tbl, "\n"))
    return ...
  end

  RELOAD = function(...)
    return reloader(...)
  end

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

return {
  "nvim-lua/plenary.nvim",
  config = config,
  event = "BufReadPre",
}
