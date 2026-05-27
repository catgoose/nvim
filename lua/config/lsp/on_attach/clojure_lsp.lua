local M = {}

local function with_conjure_eval(f)
  local ok, eval = pcall(require, "conjure.eval")
  if ok and eval then
    return f(eval)
  end

  vim.notify("Conjure eval is unavailable", vim.log.levels.WARN)
end

local function node_text(node, bufnr)
  if not node then
    return nil
  end

  if vim.treesitter.get_node_text then
    return vim.treesitter.get_node_text(node, bufnr)
  end

  return vim.treesitter.query.get_node_text(node, bufnr)
end

local function current_ts_node(bufnr)
  return vim.treesitter.get_node({
    bufnr = bufnr,
    ignore_injections = false,
  })
end

local function range_from_node(node)
  if not node then
    return nil
  end

  local sr, sc, er, ec = node:range()
  return {
    start = { sr + 1, sc },
    ["end"] = { er + 1, ec - 1 },
  }
end

local simple_comment_element_nodes = {
  sym_lit = true,
  kwd_lit = true,
  str_lit = true,
  num_lit = true,
  bool_lit = true,
  nil_lit = true,
  char_lit = true,
  regex_lit = true,
}

local function simple_comment_element_node(node)
  local current = node

  while current do
    if simple_comment_element_nodes[current:type()] then
      return current
    end

    if current:type() == "list_lit" or current:type() == "vec_lit" or current:type() == "map_lit" then
      return nil
    end

    current = current:parent()
  end
end

local function head_list_for_element(element_node)
  if not element_node then
    return nil
  end

  local parent = element_node:parent()
  if not parent or parent:type() ~= "list_lit" then
    return nil
  end

  if parent:named_child(0) == element_node then
    return parent
  end
end

local function enclosing_comment_list(bufnr)
  local node = current_ts_node(bufnr)

  while node do
    if node:type() == "list_lit" then
      local head = node:named_child(0)
      if head and vim.trim(node_text(head, bufnr) or "") == "comment" then
        return node
      end
    end
    node = node:parent()
  end
end

local function cursor_on_outer_comment(bufnr, comment_node)
  local node = current_ts_node(bufnr)
  if not node or not comment_node then
    return false
  end

  if node == comment_node then
    return true
  end

  local head = comment_node:named_child(0)
  return head ~= nil and node == head
end

local function comment_body_eval_input(bufnr, comment_node)
  if not comment_node then
    return nil
  end

  local first_body = comment_node:named_child(1)
  local last_body
  local idx = 1

  while true do
    local child = comment_node:named_child(idx)
    if not child then
      break
    end
    last_body = child
    idx = idx + 1
  end

  if not first_body or not last_body then
    return nil
  end

  local sr, sc = first_body:start()
  local er, ec = last_body:end_()
  local lines = vim.api.nvim_buf_get_text(bufnr, sr, sc, er, ec, {})
  local code = table.concat(lines, "\n")
  if code == "" then
    return nil
  end

  local end_col = ec > 0 and (ec - 1) or 0
  return {
    code = code,
    range = {
      start = { sr + 1, sc },
      ["end"] = { er + 1, end_col },
    },
    origin = "comment-body",
  }
end

local function eval_current_form()
  with_conjure_eval(function(eval)
    if eval["current-form"] then
      eval["current-form"]()
      return
    end

    vim.notify("Conjure current-form eval is unavailable", vim.log.levels.WARN)
  end)
end

local function eval_exact_node(node)
  with_conjure_eval(function(eval)
    local bufnr = vim.api.nvim_get_current_buf()
    local code = node_text(node, bufnr)
    local range = range_from_node(node)
    if not code or code == "" or not range or not eval["eval-str"] then
      return
    end

    eval["eval-str"]({
      code = code,
      range = range,
      origin = "comment-element",
      node = node,
    })
  end)
end

local function eval_context_aware()
  with_conjure_eval(function(eval)
    local bufnr = vim.api.nvim_get_current_buf()
    local comment_node = enclosing_comment_list(bufnr)
    local current_node = current_ts_node(bufnr)

    if not comment_node then
      if eval["current-form"] then
        eval["current-form"]()
        return
      end

      vim.notify("Conjure current-form eval is unavailable", vim.log.levels.WARN)
      return
    end

    if cursor_on_outer_comment(bufnr, comment_node) then
      local input = comment_body_eval_input(bufnr, comment_node)
      if input and eval["eval-str"] then
        eval["eval-str"](input)
        return
      end
    end

    local element_node = simple_comment_element_node(current_node)
    local head_list = head_list_for_element(element_node)

    if head_list then
      if head_list == comment_node then
        local input = comment_body_eval_input(bufnr, comment_node)
        if input and eval["eval-str"] then
          eval["eval-str"](input)
          return
        end
      end

      if eval["current-form"] then
        eval["current-form"]()
        return
      end
    end

    if element_node then
      eval_exact_node(element_node)
      return
    end

    if eval["current-form"] then
      eval["current-form"]()
      return
    end

    vim.notify("Conjure current-form eval is unavailable", vim.log.levels.WARN)
  end)
end

local function eval_visual_selection()
  with_conjure_eval(function(eval)
    if eval.selection then
      eval.selection(vim.fn.visualmode())
      return
    end

    vim.notify("Conjure visual eval is unavailable", vim.log.levels.WARN)
  end)
end

---@diagnostic disable-next-line: unused-local
function M.on_attach(client, bufnr)
  local normal_opts = {
    noremap = true,
    silent = true,
    buffer = bufnr,
    desc = "Conjure eval current thing",
  }

  local visual_opts = {
    noremap = true,
    silent = true,
    buffer = bufnr,
    desc = "Conjure eval visual selection",
  }

  vim.keymap.set("n", "<leader>k", eval_context_aware, normal_opts)
  vim.keymap.set("x", "<leader>k", eval_visual_selection, visual_opts)
end

return M
