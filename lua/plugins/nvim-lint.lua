return {
  {
    "mfussenegger/nvim-lint",
    -- dir = "~/git/nvim-lint",
    event = "VeryLazy",
    lazy = true,
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint_d", "oxlint" },
        typescript = { "eslint_d", "oxlint" },
        vue = { "eslint_d", "oxlint" },
        docker = { "hadolint" },
        fish = { "fish" },
        json = { "jsonlint" },
        markdown = { "markdownlint" },
        editorconfig = { "editorconfig-checker" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        go = { "golangcilint", "fieldalignment", "staticcheck" },
      }

      lint.linters.codespell.args = { "--ignore-words ~/.config/codespell/ignore_words" }

      local ignore_buftype = {
        markdown = { "nofile" },
      }

      lint.linters.fieldalignment = {
        name = "fieldalignment",
        cmd = "fieldalignment",
        args = { "-json" },
        stdin = false,
        stream = "stdout",
        ignore_exitcode = true,
        parser = function(output, bufnr)
          if output == "" then
            return {}
          end
          local decoded = vim.json.decode(output, { luanil = { object = true, array = true } })
          local diagnostics = {}
          for _, issues in pairs(decoded) do
            for _, issue_list in pairs(issues) do
              for _, issue in ipairs(issue_list) do
                local pos = issue.posn
                local _, lnum, col = pos:match("^(.+):(%d+):(%d+)$")
                lnum = tonumber(lnum) or 1
                col = tonumber(col) or 1
                local message = issue.message
                local suggested_fix = ""
                if issue.suggested_fixes and #issue.suggested_fixes > 0 then
                  local fix = issue.suggested_fixes[1]
                  if fix.edits and #fix.edits > 0 then
                    suggested_fix = fix.edits[1].new
                    suggested_fix = suggested_fix:gsub("\n", "\n\t"):gsub("\t", "  ")
                    message = message .. "\nSuggested struct:\n" .. suggested_fix
                  end
                end
                table.insert(diagnostics, {
                  bufnr = bufnr,
                  lnum = lnum - 1,
                  col = col - 1,
                  end_lnum = lnum - 1,
                  end_col = col - 1,
                  severity = vim.diagnostic.severity.WARN,
                  message = message,
                  source = "fieldalignment",
                })
              end
            end
          end
          return diagnostics
        end,
      }

      -- TODO: 2025-07-31 - Do we need to do this?
      lint.linters.golangcilint.args = {
        "run",
        "--output.json.path=stdout",
        "--show-stats=false",
        "--output.text.print-issued-lines=false",
        "--output.text.print-linter-name=false",
        function()
          return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
        end,
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("lint", { clear = true }),
        callback = function()
          if ignore_buftype[vim.bo.filetype] then
            for _, buftype in ipairs(ignore_buftype[vim.bo.filetype]) do
              if buftype == vim.bo.buftype then
                return
              end
            end
          end
          -- pcall(lint, "try_lint")
          lint.try_lint()
          lint.try_lint({ "codespell" })
        end,
      })
    end,
  },
}
