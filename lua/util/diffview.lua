local M = {}

local function get_branches(config)
  config = config or { current = false }
  local branches = {}
  local git_cmd = config.current and "git rev-parse --abbrev-ref HEAD"
    or "git branch --format='%(refname:short)'"
  local handle = io.popen(git_cmd)
  if not handle then
    return branches
  end
  for branch in handle:lines() do
    table.insert(branches, branch)
  end
  handle:close()
  if #branches == 0 then
    return
  end
  return config.current and branches[1] or branches
end

local function open_diff_view(branch)
  local diff = string.format("DiffviewOpen %s...HEAD", branch)
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, diff)
end

local function open_if_single_branch(branches)
  if not branches or #branches == 0 then
    return
  end
  if #branches == 1 then
    local diff = string.format("DiffviewOpen %s", branches[1])
    ---@diagnostic disable-next-line: param-type-mismatch
    pcall(vim.cmd, diff)
    return true
  end
end

function M.main()
  local branches = get_branches()
  if not branches then
    return
  end
  if open_if_single_branch(branches) then
    return
  end

  local default_branches = { "main", "master" }
  for _, branch in ipairs(default_branches) do
    if vim.tbl_contains(branches, branch) then
      open_diff_view(branch)
      return
    end
  end
  M.prompt()
end

function M.prompt()
  local branches = get_branches()
  if not branches then
    return
  end
  if open_if_single_branch(branches) then
    return
  end
  if #branches > 1 then
    local current = get_branches({ current = true })
    branches = vim.tbl_filter(function(branch)
      return current ~= branch
    end, branches)
  end

  vim.ui.select(branches, {
    prompt = "Select branch",
  }, function(selected)
    if not selected then
      return
    end
    open_diff_view(selected)
  end)
end

return M
