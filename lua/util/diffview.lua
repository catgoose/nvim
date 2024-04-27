local M = {}

local default_branches = { "main", "master" }

local function git_branches()
  local branches = {}
  local handle = io.popen("git branch --format='%(refname:short)'")
  if not handle then
    return branches
  end
  for branch in handle:lines() do
    table.insert(branches, branch)
  end
  handle:close()
  return branches
end

local open_diff_view = function(branch)
  local diff = string.format("DiffviewOpen %s...HEAD", branch)
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, diff)
end

function M.open()
  local branches = git_branches()
  if not branches or #branches == 0 then
    return
  end

  if #branches == 1 then
    open_diff_view(branches[1])
  end

  for _, branch in ipairs(default_branches) do
    if vim.tbl_contains(branches, branch) then
      open_diff_view(branch)
      return
    end
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
