function: (member_expression
 object: (this)
 property: (property_identifier) @this_method_call
)
 (member_expression
    object: (member_expression
      object: (this)
      property: (property_identifier)
    )
    property: (property_identifier) @this_method_call
  )

(call_expression
  function: (member_expression
    object: (this)
    property: [
      (private_property_identifier) @private (#match? @private "^(!(#error|#debug)).*")
      (property_identifier)
    ] @method_object_call
  )
)
(call_expression
  function: (member_expression
    object: (member_expression
      object: (this)
      property: (property_identifier)
    )
    property: [
      (property_identifier)
      (private_property_identifier)
    ] @method_object_call
  )
)

(object
  (pair
    key: (property_identifier) @object_key
    value: [
      (string)
      (number)
      (true)
      (false)
      (null)
      (undefined)
      (template_string)
      (object)
      (array)
    ] @object_value)
)
 
(lexical_declaration
  (variable_declarator
    name: (identifier)
    value: (object) @object_declaration
)) 

(method_definition parameters: (formal_parameters
  [
   (required_parameter)
   (optional_parameter)
   ] @method_parameter))
