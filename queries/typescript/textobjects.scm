(call_expression
  function: (member_expression
    object: (this)
    property: [
      (private_property_identifier) @private (#match? @private "^(!(#error|#debug)).*")
      (property_identifier)
    ] @property_call
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
    ] @property_call
  )
)
