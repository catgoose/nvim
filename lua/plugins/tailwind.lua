local ft = { "vue", "html" }
return {
  {
    -- "MaximilianLloyd/tw-values.nvim",
    dir = "~/git/tw-values.nvim",
    opts = {
      focus_preview = true,
    },
    lazy = true,
    ft = ft,
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    opts = {
      color_square_width = 2,
    },
    event = "InsertEnter",
  },
  -- {
  --   dir = "~/git/tailwind-tools.nvim/",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   opts = {
  --     conceal = {
  --       enabled = true,
  --       min_length = 80,
  --       symbol = "󱏿",
  --       highlight = {
  --         fg = "#38BDF8",
  --       },
  --     },
  --   },
  --   ft = { "vue", "html" },
  --   event = "BufReadPre",
  -- },
}
