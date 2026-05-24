{ lib, flake-parts-lib, }: 
{ functionsDir, OptionDeclsDir, defaultOptionDeclsFile, pkgs, }: 
let 
  inherit (flake-parts-lib) importApply; 

  # 1. Discover files
  discoveredNixFiles = lib.filterAttrs 
    (fileName: fileType: fileType == "regular" && lib.hasSuffix ".nix" fileName) 
    (builtins.readDir functionsDir); 

  # 2. Pre-evaluated, static metadata map
  # In a literal attribute set, keys are flat names, not paths like `config.foo`
  staticPerFunctionOptionsSchema = lib.mapAttrs (fileName: _: 
    let 
      BuilderName = lib.removeSuffix ".nix" fileName;
      _scopedOptionDeclsFile = (toString OptionDeclsDir) + "/${BuilderName}.nix";
    in {
      # Seed values passed as a raw attribute set directly to the submodule default template
      BuilderName = BuilderName;
      _scopedOptionDeclsFile = _scopedOptionDeclsFile;
      _hasScopedDecls = builtins.pathExists _scopedOptionDeclsFile;
      builderOptionsSchema = {}; 
    }
  ) discoveredNixFiles;

  # 3. Submodule schema correctly accepting config and options as arguments
  builderSubmodule = { config, options, ... }: { 
    options = { 
      BuilderName = lib.mkOption { 
        type = lib.types.str; 
        # Safely extracts the default value from the static metadata map seed
        default = staticPerFunctionOptionsSchema.${BuilderName}; 
      }; 

      # Hidden structural internal options used for mapping
      _scopedOptionDeclsFile = lib.mkOption { 
        type = lib.types.str; 
        internal = true; 
        default = staticPerFunctionOptionsSchema.${BuilderName}._scopedOptionDeclsFile; 
      };
      
      _hasScopedDecls = lib.mkOption { 
        type = lib.types.bool; 
        internal = true; 
        default = staticPerFunctionOptionsSchema.${BuilderName}._hasScopedDecls;
      };

      builderOutputModule = lib.mkOption { 
        type = lib.types.deferredModule; 
        description = "Pure options schema module for downstream injection."; 
        
        default = { ... }: {
          options = {
            # Safely referencing the value via the validated options/config context
            builders.${options.BuilderName.value} = {
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
    default = staticPerFunctionOptionsSchema; 
    description = "Dynamically discovered and declared builder schemas."; 
  }; 
}
