{ lib, flake-parts-lib, }: 
{ functionsDir, OptionDeclsDir, defaultOptionDeclsFile, pkgs, }: 
let 
  inherit (flake-parts-lib) importApply; 

  # 1. Discover files
  discoveredNixFiles = lib.filterAttrs 
    (fileName: fileType: fileType == "regular" && lib.hasSuffix ".nix" fileName) 
    (builtins.readDir functionsDir); 

  # 2. Pre-evaluated, fully populated static metadata map
  staticBuildersSchemaDefaults = lib.mapAttrs (fileName: _: 
    let 
      BuilderName = lib.removeSuffix ".nix" fileName;
      declPath = (toString OptionDeclsDir) + "/${BuilderName}.nix";
    in {
      # We define these as static configurations that seed the submodule
      builderName = BuilderName;
      _scopedOptionDeclsFile = declPath;
      _hasScopedDecls = builtins.pathExists declPath;
      builderOptionsSchema = {}; 
    }
  ) discoveredNixFiles;

  # 3. Submodule schema directly extracts the top-level pre-calculated matrix values
  builderSubmodule = { config, ... }: { 
    options = { 
      builderName = lib.mkOption { 
        type = lib.types.str; 
        default = config.builderName; # Pulls directly from pre-evaluated matrix
      }; 

      # Hidden structural internal options used for mapping
      _scopedOptionDeclsFile = lib.mkOption { type = lib.types.str; internal = true; };
      _hasScopedDecls = lib.mkOption { type = lib.types.bool; internal = true; };

      builderOutputModule = lib.mkOption { 
        type = lib.types.deferredModule; 
        description = "Pure options schema module for downstream injection."; 
        
        default = { ... }: {
          options = {
            builders.${config.builderName} = {
              imports = [ defaultOptionDeclsFile ] 
                ++ lib.optional config._hasScopedDecls config._scopedOptionDeclsFile; 
            };
          };
        }; 
      }; 
    }; 
  }; 
in { 
  # 4. Bind the default values directly to the static mapping
  options.builders = lib.mkOption { 
    type = lib.types.lazyAttrsOf (lib.types.submodule builderSubmodule); 
    default = staticBuildersSchemaDefaults; 
    description = "Dynamically discovered and declared builder schemas."; 
  }; 
}
