# Accepts absolute or relative paths, and/or strings
#But - will convert rel-paths to absolutes and copy to nix store
# so be sure to quote any paths before hand-off
nixpkgs.lib.strings.fileExtension path

#quote Relative Paths  
## options

quoteRelativePath p: pkgs.lib.escapeShellArg p;
quoteRelativePath = p: "\"${p}\"";
