local u = require("util")
local m = u.lazy_map

local Job = require("plenary.job")

local function get_os_command_output(cmd, cwd)
  if type(cmd) ~= "table" then
    return {}
  end
  local command = table.remove(cmd, 1)
  local stderr = {}
  ---@diagnostic disable-next-line: missing-fields
  local stdout, ret = Job:new({
    command = command,
    args = cmd,
    cwd = cwd,
    on_stderr = function(_, data)
      table.insert(stderr, data)
    end,
  }):sync()
  return stdout, ret, stderr
end

local function get_branch()
  local branch = get_os_command_output({
    "git",
    "rev-parse",
    "--abbrev-ref",
    "HEAD",
  })[1]
  if branch then
    return string.format("%s-%s", vim.fn.getcwd(), branch)
  else
    return vim.fn.getcwd()
  end
end

local opts = {
  settings = {
    sync_on_ui_close = true,
    save_on_toggle = true,
    -- key = function()
    --   return get_branch()
    -- end,
  },
}

return {
  "ThePrimeagen/harpoon",
  opts = opts,
  keys = {
    m("<leader>a", function()
      require("harpoon"):list():add()
    end, { "n", "x" }),
    m("<leader>l", function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { "n", "x" }),
    m("<leader>,", function()
      require("harpoon"):list():next({
        ui_nav_wrap = true,
      })
    end, { "n", "x" }),
    m("<leader>.", function()
      require("harpoon"):list():prev({
        ui_nav_wrap = true,
      })
    end, { "n", "x" }),
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "pockata/harpoon-highlight-current-file",
      config = true,
    },
  },
  branch = "harpoon2",
  -- commit = "e76cb03",
}
