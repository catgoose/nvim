[
  "on"
  "def"
  "end"
  "behavior"
  "set"
  "then"
  "return"
] @keyword

[
	(event_name)
    (IDENTIFIER)
    (OBJECT_ACCESS)
    (symbol)
    (CSS_CLASS)
    (TARGET_EXPRESSION)
] @variable

[
  "to"
  "on"
  (operator)
] @operator

[
	(STRING)
] @string

[
	(NUMBER)
  (OBJECT_LITERAL)
] @literal

(comment) @comment

[
	(command)
] @call
