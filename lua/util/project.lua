local M = {}

local projects = {
	helpgrep = {
		keys = {},
		dev_keys = {
			{
				"<leader>z",
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
				"<leader>z",
				function()
					vim.cmd([[Lazy reload vue-goto-definition.nvim]])
				end,
			},
		},
	},
	["do-the-needful"] = {
		keys = {},
		dev_keys = {
			{
				"<leader>z",
				function()
					vim.cmd([[Lazy reload do-the-needful.nvim]])
					vim.cmd([[Lazy reload telescope.nvim]])
				end,
			},
		},
	},
}

-- M.current_project = nil
-- M.current_project = projects.helpgrep
M.current_project = projects["vue-goto-definition"]
-- M.current_project = projects["do-the-needful"]

local function get_project_property(project_name, property_type)
	local project = projects[project_name]
	if not project then
		return nil
	end
	local property = nil
	if project == M.current_project then
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

return M
