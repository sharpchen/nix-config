; inherits: c_sharp

; already merged to nvim-treesitter-textobjects:
; ; method without body(abstract method/metadata)
; (method_declaration
;   _+
;   ";") @function.outer
;
; (method_declaration
;   body: (block
;     .
;     "{"
;     _* @function.inner ; match on empty body
;     "}")) @function.outer
;
; (local_function_statement
;   body: (block
;     .
;     "{"
;     _* @function.inner
;     "}")) @function.outer
;
; (local_function_statement
;   body: (arrow_expression_clause
;     "=>"
;     _+ @function.inner)) @function.outer
;
; (anonymous_method_expression
;   (block
;     .
;     "{"
;     _* @function.inner
;     "}")) @function.outer
;
; (property_declaration
;   accessors: (accessor_list
;     (accessor_declaration
;       body: (block
;         .
;         "{"
;         _* @function.inner
;         "}")) @function.outer))
;
; (property_declaration
;   accessors: (accessor_list
;     (accessor_declaration
;       body: (arrow_expression_clause
;         "=>"
;         _* @function.inner)) @function.outer))
;
; (property_declaration
;   value: (arrow_expression_clause
;     "=>"
;     _+ @function.inner)) @function.outer
;
; (indexer_declaration
;   accessors: (accessor_list
;     (accessor_declaration
;       body: (arrow_expression_clause
;         "=>"
;         _+ @function.inner)) @function.outer))
;
; (indexer_declaration
;   accessors: (accessor_list
;     (accessor_declaration
;       body: (block
;         .
;         "{"
;         _* @function.inner
;         "}")) @function.outer))
;
; (conversion_operator_declaration
;   body: (block
;     .
;     "{"
;     _* @function.inner
;     "}")) @function.outer
;
; (conversion_operator_declaration
;   body: (arrow_expression_clause
;     "=>"
;     _+ @function.inner)) @function.outer
;
; (operator_declaration
;   body: (block
;     .
;     "{"
;     _* @function.inner
;     "}")) @function.outer
;
; (operator_declaration
;   body: (arrow_expression_clause
;     "=>"
;     _+ @function.inner)) @function.outer
;
; ; operator without body(abstract)
; (operator_declaration
;   _+
;   ";") @function.outer
;
; (constructor_declaration
;   body: (block
;     .
;     "{"
;     _* @function.inner ; match on empty body
;     "}")) @function.outer
;
; ; constructor without body(metadata)
; (constructor_declaration
;   _+
;   ";") @function.outer
