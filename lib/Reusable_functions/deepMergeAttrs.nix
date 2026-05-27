let
  # Deep merge two attribute sets recursively
  recursiveMerge = attrList:
    let
      f = prev: cur:
        if builtins.isAttrs prev && builtins.isAttrs cur
        then builtins.zipAttrsWith (name: values: recursiveMerge values) [ prev cur ]
        else cur;
    in
      builtins.foldl' f {} attrList;
in
  recursiveMerge [ { a = { b = 1; }; } { a = { c = 2; }; } ] 
  # Returns: { a = { b = 1; c = 2; }; }
