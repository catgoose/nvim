local t = require("util.ts-node-action")
local u = require("util")
local m = u.lazy_map

--  TODO: 2024-05-14 - create node action for toggling json/jsonc arrays and
--  objects multiline
local html = {
  ["attribute_name"] = function(tsnode)
    return t.vue.class_action(tsnode)
  end,
  ["attribute_value"] = function(tsnode)
    local parent = tsnode:parent()
    if not parent then
      return
    end
    local sibling = parent:prev_named_sibling()
    if not sibling then
      return
    end
    return t.vue.class_action(sibling)
  end,
  ["quoted_attribute_value"] = function(tsnode)
    local sibling = tsnode:prev_named_sibling()
    if not sibling then
      return
    end
    return t.vue.class_action(sibling)
  end,
}

return {
  "CKolkey/ts-node-action",
  opts = {
    html = html,
    vue = html,
  },
  keys = {
    m("<leader>i", [[lua require("ts-node-action").node_action()]]),
  },
}
