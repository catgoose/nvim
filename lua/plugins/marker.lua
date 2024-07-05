return {
  "atusy/tsnode-marker.nvim",
  lazy = true,
  ft = "markdown",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("tsnode-marker-markdown", {}),
      pattern = "markdown",
      callback = function(ctx)
        if vim.bo.buftype ~= "nofile" then
          require("tsnode-marker").set_automark(ctx.buf, {
            target = { "code_fence_content" },
            hl_group = "CursorLine",
          })
        end
      end,
    })
  end,
}
