; _hyperscript attribute
(attribute
    (attribute_name) @_attr
        (#eq? @_attr "_")
    (quoted_attribute_value
        (attribute_value) @injection.content)
    (#set! injection.language "hyperscript"))

