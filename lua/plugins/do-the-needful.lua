local dev = false
local enabled = true
local e = vim.tbl_extend
local m = require("util").lazy_map
local project = require("util.project")

local opts = {
  dev = dev,
  log_level = "info",
  edit_mode = "tab",
  config_order = {
    "project",
    "global",
    "opts",
  },
  tasks = {
    {
      name = "push dotfiles",
      cmd = "fish -c 'dotfiles_push'",
      cwd = "~/git/dotfiles",
      tags = { "dotfiles", "update", "nvim", "repo", "sync" },
      window = {
        close = true,
        keep_current = true,
      },
    },
    {
      name = "pull main",
      cmd = "fish -c 'pm'",
      tags = { "git", "pull", "main" },
      window = {
        close = false,
        keep_current = true,
      },
    },
    {
      name = "git rename branch",
      cmd = "fish -c git_rename_branch",
      tags = { "git", "rename", "branch" },
      window = {
        close = true,
        keep_current = false,
      },
    },
  },
}

local keys = {
  m("<leader>;", [[Telescope do-the-needful please]]),
  m("<leader>:", [[Telescope do-the-needful]]),
}
keys = project.get_keys("do-the-needful", keys)

local plugin = {
  dependencies = "nvim-lua/plenary.nvim",
  opts = opts,
  keys = keys,
  enabled = enabled,
}

if dev == true then
  return e("keep", plugin, {
    dir = "~/git/do-the-needful.nvim",
    lazy = false,
  })
else
  return e("keep", plugin, {
    "catgoose/do-the-needful.nvim",
    event = "BufReadPre",
  })
end
