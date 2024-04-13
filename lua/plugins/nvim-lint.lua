--  TODO: 2024-04-12 - add linters for write-good, dotenv-linter
local linters = {
    js = { "eslint_d" },
    sh = { "shellcheck" },
    all = { "codespell" },
}

return {
    "mfussenegger/nvim-lint",
    event = "BufReadPre",
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            javascript = linters.js,
            typescript = linters.js,
            vue = linters.js,
            docker = { "hadolint" },
            fish = { "fish" },
            -- env = { "dotenv-linter" },
            json = { "jsonlint" },
            -- markdown = { "markdownlint", "vale", "write-good", "cbfmt" },
            markdown = { "markdownlint", "vale" },
            editorconfig = { "editorconfig-checker" },
            sh = linters.sh,
            bash = linters.sh,
        }

        lint.linters.codespell.args = { "--ignore-words=~/.config/codespell/ignore_word" }

        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
            group = vim.api.nvim_create_augroup("lint", { clear = true }),
            callback = function()
                lint.try_lint()
                lint.try_lint(linters.all)
            end,
        })
    end,
}
