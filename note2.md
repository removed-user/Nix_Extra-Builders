# importer.nix
{ lib, flake-parts-lib }:
{ functionsDir, configsDir, defaultConfigFile, pkgs }:
let
  inherit (flake-parts-lib) importApply;
  
  # Auto-discover the function files
  dirContents = builtins.readDir functionsDir;
  nixFiles = lib.filterAttrs 
    (name: type: type == "regular" && lib.hasSuffix ".nix" name) 
    dirContents;

  # Submodule schema declaration (generic Nix evaluation)
  builderSubmodule = runtimePaths: { ... }: {
    options = {
      name = lib.mkOption { type = lib.types.str; };
      cfg = lib.mkOption {
        type = lib.types.submodule {
          options = {
            packagePath = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
            packageArgs = lib.mkOption { type = lib.types.attrs; default = { }; };
          };
        };
      };
      outputModule = lib.mkOption { type = lib.types.deferredModule; };
    };

    config = {
      cfg = lib.mkMerge [
        (import defaultConfigFile)
        (if builtins.pathExists runtimePaths.scopedConfigFile then import runtimePaths.scopedConfigFile else { })
      ];

      # importApply binds the scoped dependencies safely
      outputModule = importApply runtimePaths.functionFile {
        inherit pkgs;
        cfg = runtimePaths.config.cfg;
      };
    };
  };

in
# Map discovered files into a type-safe list of evaluated attribute sets
builtins.map (name:
  let
    cleanName = lib.removeSuffix ".nix" name;
    functionFile = functionsDir + "/${name}";
    scopedConfigFile = configsDir + "/${cleanName}.nix";
    
    # Isolated module system invocation
    evaluated = lib.modules.evalModules {
      modules = [
        (builderSubmodule { inherit functionFile scopedConfigFile; inherit (evaluated) config; })
        { name = cleanName; }
      ];
    };
  in
  {
    inherit (evaluated) config options;
    cfg = evaluated.config.cfg;
    # Expose the raw evaluated payload out of the module
    output = evaluated.config.outputModule; 
  }
) (builtins.attrNames nixFiles)
