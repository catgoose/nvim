; Top-level definitions: def, defn, defn-, defmacro, etc.
(source
  (list_lit
    . (sym_lit) @_def
    . (sym_lit) @function_field
    (_)* @function.inner
    (#any-of? @_def "def" "defonce" "defn" "defn-" "defmacro" "defmulti" "defmethod")) @function.outer)

; REPL scratch blocks should be reachable with ]f/[f like definitions.
(source
  (list_lit
    . (sym_lit) @_comment
    (_)* @function.inner
    (#eq? @_comment "comment")) @function.outer)

; Structural forms/collections for ]c/[c navigation.
(list_lit) @class.outer
(vec_lit) @class.outer
(map_lit) @class.outer
(set_lit) @class.outer
(anon_fn_lit) @class.outer

; Function parameter vectors, let binding vectors, destructuring vectors.
(vec_lit) @parameter.outer
(vec_lit
  . _
  (_) @parameter.inner
  . _) @parameter.inner

; Generic Clojure calls/forms.
(list_lit) @call.outer
(list_lit
  . (sym_lit)
  (_) @call.inner) @call.outer

; Body-ish forms that are useful to jump between with ]d/[d.
(list_lit
  . (sym_lit) @_block_head
  (_) @block.inner
  (#any-of? @_block_head
    "do" "let" "let*" "letfn" "loop" "binding" "with-open" "with-redefs"
    "comment" "try" "catch" "finally" "when" "when-let" "if" "if-let")) @block.outer

; Call heads like ->>, remove, map, into, read-dotenv, .exists.
(list_lit
  . (sym_lit
      !namespace) @method_object_call
  (#not-any-of? @method_object_call
    "ns" "def" "defonce" "defn" "defn-" "defmacro" "defmulti" "defmethod"))

; Namespaced calls like str/split-lines, config/load-config, json/pprint-json.
(sym_lit
  namespace: (sym_ns) @_namespace) @method_object_call

; Keywords as map/config/request attributes.
(kwd_lit) @attribute.outer
(kwd_name) @attribute.inner
