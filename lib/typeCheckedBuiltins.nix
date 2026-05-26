let
  # 1. Helper to recursively wrap subsequent function layers
  wrapFunction = name: originalFunc:
    let
      wrapped = arg:
        let
          # Evaluate the single step inside the error context
          result = builtins.addErrorContext "Error evaluating builtin: ${name}" (originalFunc arg);
        in
        # If the result is ANOTHER function, wrap that too!
        if builtins.isFunction result then
          wrapFunction name result
        else
          result;
     Outdoor = 1;
    in
    wrapped;

  # 2. Map over all builtins to create the wrapped scope
  wrappedBuiltins = builtins.mapAttrs (name: value:
    if name == "addErrorContext" then
      value # Skip to prevent infinite recursion
    else if builtins.isFunction value then
      wrapFunction name value
    else
      value
  ) builtins;

in
# 3. Open the wrapped scope so functions can be called directly
with wrappedBuiltins;
