  (attribute
    (attribute_name) @attr_name
      (quoted_attribute_value (attribute_value) @method_object_call)
      (#match? @attr_name "class")
  )

(script_element
  (start_tag
    (attribute
      (quoted_attribute_value
        (attribute_value) @lang
        )
      )
    ) @start_tag
  (#match? @lang "ts")
  ) @function.inner

(template_element
  ( element) @block.inner
  )
