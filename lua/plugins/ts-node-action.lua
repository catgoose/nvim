local t = require("util.ts-node-action")
local u = require("util")
local m = u.lazy_map

return {
  "CKolkey/ts-node-action",
  opts = {
    vue = {
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
    },
  },
  keys = {
    m("<leader>i", [[lua require("ts-node-action").node_action()]]),
  },
}
