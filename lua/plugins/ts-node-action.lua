local t = require("util.ts-node-action")
local u = require("util")
local m = u.lazy_map

local html = {
  ["tag_name"] = function(tsnode)
    return t.vue.tag_name(tsnode)
  end,
  ["attribute_name"] = function(tsnode)
    local sibling = tsnode:next_named_sibling()
    if not sibling then
      return
    end
    return t.vue.attribute_name(tsnode)
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
    return t.vue.attribute_name(sibling)
  end,
  ["quoted_attribute_value"] = function(tsnode)
    local sibling = tsnode:prev_named_sibling()
    if not sibling then
      return
    end
    return t.vue.attribute_name(sibling)
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
