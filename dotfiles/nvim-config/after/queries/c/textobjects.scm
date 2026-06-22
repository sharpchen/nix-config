; inherits: c

((comment) @comment.chunk
  (#lua-match? @comment.chunk "^/%*"))

((comment)+ @comment.chunk
  (#not-any-lua-match? @comment.chunk "^/%*"))
