; (element) @function.outer

(element
  (tag_start)
  .
  (_) @function.inner
  .
  (tag_end))

(attribute_value) @attribute.inner

(attribute) @attribute.outer

((element
  (tag_start)
  .
  (_) @_start
  (_) @_end
  .
  (tag_end))
  (#make-range! "function.inner" @_start @_end))

; (script_element) @function.outer

((script_element (script_element_text) @function.inner))

; (style_element) @function.outer

(style_element
  (style_tag_start)
  .
  (_) @function.inner
  .
  (style_tag_end))

; ((element
;   (tag_start
;     (element_identifier) @_tag)) @class.outer
;   (#match? @_tag "^(html|section|h[0-9]|header|title|head|body)$"))

((element
  (tag_start
    (element_identifier) @_tag)
  .
  (_) @class.inner
  .
  (tag_end))
  (#match? @_tag "^(html|section|h[0-9]|header|title|head|body)$"))
((element
  (tag_start
    (element_identifier) @_tag)
  .
  (_) @_start
  (_) @_end
  .
  (tag_end))
  (#match? @_tag "^(html|section|h[0-9]|header|title|head|body)$")
  (#make-range! "class.inner" @_start @_end))

; ((component_declaration) @class.outer)
((component_declaration
  (component_block) @class.inner))

(comment) @comment.outer

(component_declaration) @function.outer
(component_declaration name: (component_identifier) @function_field)
(component_if_statement) @block.inner
(component_for_statement) @block.inner
(component_import) @method_object_call
; (attribute name: (attribute_name) value: (quoted_attribute_value (attribute_value))) @class.outer
(attribute name: (attribute_name)) @class.outer
(function_declaration) @function.outer
((element
  (tag_start
    (element_identifier) @parameter.inner))
  (#match? @parameter.inner "^(html|section|h[0-9]|header|title|head|body|div)$"))
