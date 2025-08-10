local t = require("util.ts-node-action")
local u = require("util")
local m = u.lazy_map

local html = {
  ["start_tag"] = function(tsnode)
    local child = tsnode:named_child()
    if not child then
      return
    end
    return t.html.tag_name(child)
  end,
  ["self_closing_tag"] = function(tsnode)
    local child = tsnode:named_child()
    if not child then
      return
    end
    return t.html.tag_name(child)
  end,
  ["tag_name"] = function(tsnode)
    return t.html.tag_name(tsnode)
  end,
  ["attribute_name"] = function(tsnode)
    local sibling = tsnode:next_named_sibling()
    if not sibling then
      return
    end
    return t.html.attribute_name(tsnode)
  end,
  ["directive_name"] = function(tsnode)
    local parent = tsnode:parent()
    if not parent then
      return
    end
    return t.html.handle_attribute(parent)
  end,
  ["directive_attribute"] = function(tsnode)
    return t.html.handle_attribute(tsnode)
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
    return t.html.attribute_name(sibling)
  end,
  ["quoted_attribute_value"] = function(tsnode)
    local sibling = tsnode:prev_named_sibling()
    if not sibling then
      return
    end
    return t.html.attribute_name(sibling)
  end,
}

local templ = {
  ["tag_start"] = function(tsnode)
    local child = tsnode:named_child()
    if not child then
      return
    end
    return t.html.tag_name(child)
  end,
  ["attribute_name"] = function(tsnode)
    local sibling = tsnode:next_named_sibling()
    if not sibling then
      return
    end
    return t.html.attribute_name(tsnode)
  end,
  ["element_identifier"] = function(tsnode)
    return t.html.tag_name(tsnode)
  end,
  ["attribute"] = function(tsnode)
    return t.html.handle_attribute(tsnode)
  end,
  ["self_closing_tag"] = function(tsnode)
    local child = tsnode:named_child()
    if not child then
      return
    end
    return t.html.tag_name(child)
  end,
}

return {
  "CKolkey/ts-node-action",
  opts = {
    html = html,
    vue = html,
    angular = html,
    templ = templ,
  },
  keys = {
    m("<leader>i", [[lua require("ts-node-action").node_action()]]),
  },
}
