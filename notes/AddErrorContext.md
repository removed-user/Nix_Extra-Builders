builtins.addErrorContext skips evaluating type checks on successful runs.
keep in mind though

```nix
builtins.addErrorContext "while processing package ${pkg.name}" (someExpr)
```

