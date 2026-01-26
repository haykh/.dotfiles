; extends

((call_expression
  function: (identifier) @_ident
  arguments: (template_string
    (string_fragment) @injection.content))
  (#match? @_ident "^glsl$|^frag$|^vert$|^glslify$")
  (#set! injection.language "cpp"))
