
; _hyperscript attribute in Go's `fmt.Sprintf`
(attribute
    (attribute_name) @_attr
        (#eq? @_attr "_")
    (expression
        (call_expression
            function: (selector_expression
                operand: (identifier) @_fmt
                field: (field_identifier) @_sprintf)
            arguments: (argument_list
                (interpreted_string_literal
                    (interpreted_string_literal_content) @injection.content))))
    (#eq? @_fmt "fmt")
    (#eq? @_sprintf "Sprintf")
    (#set! injection.language "hyperscript"))

; _hyperscript attribute in Go's `fmt.Sprintf` (raw string literals - backticks)
(attribute
    (attribute_name) @_attr
        (#eq? @_attr "_")
    (expression
        (call_expression
            function: (selector_expression
                operand: (identifier) @_fmt
                field: (field_identifier) @_sprintf)
            arguments: (argument_list
                (raw_string_literal
                    (raw_string_literal_content) @injection.content))))
    (#eq? @_fmt "fmt")
    (#eq? @_sprintf "Sprintf")
    (#set! injection.language "hyperscript"))
