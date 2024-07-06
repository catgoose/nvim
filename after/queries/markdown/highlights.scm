;; extends

; list markers/bullet points
(
  ([
    (list_marker_star)
    (list_marker_plus)
    (list_marker_minus)
  ]) @markdown_list_marker
  (#offset! @markdown_list_marker 0 0 0 -1)
  (#set! conceal "•")
)

; checkboxes
((task_list_marker_unchecked) @markdown_check_undone (#set! conceal ""))
((task_list_marker_checked) @markdown_check_done (#set! conceal ""))

; box drawing characters for tables
(pipe_table_header ("|") @punctuation.special @conceal (#set! conceal "│"))
(pipe_table_delimiter_row ("|") @punctuation.special @conceal (#set! conceal "│"))
(pipe_table_delimiter_cell ("-") @punctuation.special @conceal (#set! conceal "─"))
(pipe_table_row ("|") @punctuation.special @conceal (#set! conceal "│"))

; block quotes
((block_quote_marker) @markdown_quote_marker (#set! conceal "▍"))
((block_quote
  (paragraph (inline
    (block_continuation) @markdown_quote_marker (#set! conceal "▍")
  ))
))

(
  fenced_code_block (fenced_code_block_delimiter) @markdown_code_block_marker
  (#set! conceal "")
)
(
  [(info_string (language))] @markdown_code_block_lang_javascript
  (#eq? @markdown_code_block_lang_javascript "javascript")
  (#set! conceal "")
)
(
  [(info_string (language))] @markdown_code_block_lang_typescript
  (#eq? @markdown_code_block_lang_typescript "typescript")
  (#set! conceal "")
)
(
  [(info_string (language))] @markdown_code_block_lang_json
  (#eq? @markdown_code_block_lang_json "json")
  (#set! conceal "")
)
(
  [(info_string (language))] @markdown_code_block_lang_bash
  (#eq? @markdown_code_block_lang_bash "bash")
  (#set! conceal "")
)
(
  [(info_string (language))] @markdown_code_block_lang_bash
  (#eq? @markdown_code_block_lang_bash "sh")
  (#set! conceal "")
)
(
  [(info_string (language))] @markdown_code_block_lang_lua
  (#eq? @markdown_code_block_lang_lua "lua")
  (#set! conceal "")
)
(
  [(info_string (language))] @markdown_code_block_lang_diff
  (#eq? @markdown_code_block_lang_diff "diff")
  (#set! conceal "")
)
(
  [(info_string (language))] @markdown_code_block_lang_vim
  (#eq? @markdown_code_block_lang_vim "vim")
  (#set! conceal "")
)
(
  [(info_string (language))] @markdown_code_block_lang_yaml
  (#eq? @markdown_code_block_lang_yaml "yaml")
  (#set! conceal "")
)
(
  [(info_string (language))] @markdown_code_block_lang_html
  (#eq? @markdown_code_block_lang_html "html")
  (#set! conceal "")
)
(
  [(info_string (language))] @markdown_code_block_lang_css
  (#eq? @markdown_code_block_lang_css "css")
  (#set! conceal "")
)
(
  [(info_string (language))] @markdown_code_block_lang_sql
  (#eq? @markdown_code_block_lang_sql "sql")
  (#set! conceal "")
)
(
  [(info_string (language))] @markdown_code_block_lang_sql
  (#eq? @markdown_code_block_lang_sql "go")
  (#set! conceal "")
)
