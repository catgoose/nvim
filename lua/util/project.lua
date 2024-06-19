local M = {}

local dev_key = "<leader>z"

local projects = {
  helpgrep = {
    keys = {},
    dev_keys = {
      {
        dev_key,
        function()
          vim.cmd([[Lazy reload telescope-helpgrep.nvim]])
          vim.cmd([[Lazy reload telescope.nvim]])
          vim.cmd([[Telescope helpgrep]])
        end,
        { "n" },
      },
    },
    dev_dependencies = {
      {
        dir = "~/git/telescope-helpgrep.nvim",
      },
    },
    dependencies = {
      "catgoose/telescope-helpgrep.nvim",
    },
  },
  ["vue-goto-definition"] = {
    keys = {},
    dev_keys = {
      {
        dev_key,
        function()
          vim.cmd([[Lazy reload vue-goto-definition.nvim]])
        end,
      },
      {
        "gd",
        function()
          require("vue-goto-definition").goto_definition()
        end,
      },
    },
  },
  ["do-the-needful"] = {
    keys = {},
    dev_keys = {
      {
        dev_key,
        function()
          vim.cmd([[Lazy reload do-the-needful.nvim]])
          vim.cmd([[Lazy reload telescope.nvim]])
          require("do-the-needful").please()
        end,
      },
    },
  },
  angler = {
    keys = {},
    dev_keys = {
      {
        dev_key,
        function()
          vim.cmd([[Lazy reload angler.nvim]])
        end,
      },
    },
  },
  ["nvim-ts-autotag"] = {
    keys = {},
    dev_keys = {
      {
        dev_key,
        function()
          vim.cmd([[Lazy reload nvim-ts-autotag]])
        end,
      },
    },
  },
  twvalues = {
    keys = {},
    dev_keys = {
      {
        dev_key,
        function()
          vim.cmd([[Lazy reload tw-values.nvim]])
          vim.cmd([[TWValues]])
        end,
      },
    },
  },
  ["highlight-colors"] = {
    keys = {},
    dev_keys = {
      {
        dev_key,
        function()
          vim.cmd([[Lazy reload nvim-highlight-colors]])
        end,
      },
    },
  },
}

-- local current_project = nil
-- local current_project = "highlight-colors"
-- local current_project = projects.twvalues
-- local current_project = projects.angler
-- local current_project = projects.helpgrep
local current_project = projects["do-the-needful"]
-- local current_project = projects["vue-goto-definition"]
-- local current_project = projects["nvim-ts-autotag"]

local function get_project_property(project_name, property_type)
  local project = projects[project_name]
  if not project then
    return nil
  end
  local property = nil
  if project == current_project then
    property = project["dev_" .. property_type] or {}
  else
    property = project[property_type] or {}
  end
  return property
end

function M.get_dependencies(project_name, dependencies)
  dependencies = dependencies or {}
  local _dependencies = get_project_property(project_name, "dependencies")
  if _dependencies then
    for _, dep in ipairs(_dependencies) do
      table.insert(dependencies, dep)
    end
  end
  return dependencies
end

function M.get_keys(project_name, keys)
  keys = keys or {}
  local _keys = get_project_property(project_name, "keys")
  if _keys then
    for _, dep in ipairs(_keys) do
      table.insert(keys, dep)
    end
  end
  return keys
end

function M.is_project(project_name)
  return current_project == projects[project_name]
end

return M
