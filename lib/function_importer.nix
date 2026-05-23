{
  lib,
  flake-parts-lib,
}: {
  functionsDir,
  OptionDeclsDir,
  defaultOptionDeclsFile,
  pkgs,
}: let
  inherit (flake-parts-lib) importApply;

  # 1. Discover all Nix files in the directory
  discoveredNixFiles =
    lib.filterAttrs
    (fileName: fileType: fileType == "regular" && lib.hasSuffix ".nix" fileName)
    (builtins.readDir functionsDir);

  # 2. Define a unified schema for each builder using only option declarations
  builderSubmodule = {
    name,
    config,
    ...
  }: let
    # Extract the base file name from the attribute key (e.g., "builder.nix" -> "builder")
    functionName = lib.removeSuffix ".nix" name;
    functionFile = functionsDir + "/${name}";
    scopedOptionDeclsFile = OptionDeclsDir + "/${functionName}.nix";
  in {
    options = {
      builderName = lib.mkOption {
        type = lib.types.str;
        default = functionName;
        description = "The name of the builder.";
      };

      builderOptionsSchema = lib.mkOption {
        type = lib.types.submodule;
        description = "Merged Options Schema for this specific builder.";
         imports = [ 
          (import defaultOptionDeclsFile)
          (if builtins.pathExists scopedOptionDeclsFile then import scopedOptionDeclsFile else {})
        ];
      };

      builderOutputModule = lib.mkOption {
        type = lib.types.deferredModule;
        description = "The parameterized output module generated via importApply.";
        default = importApply functionFile {
          inherit pkgs;
          cfg = config.builderOptionsSchema;
        };
      };
    };
  };

  # 3. Evaluate everything under a single, unified module definition
  evaluatedTopLevel = lib.modules.evalModules {
    modules = [
      {
        options.builders = lib.mkOption {
          type = lib.types.attrsOf (lib.types.submodule builderSubmodule);
        };
        config.builders = lib.mapAttrs (fileName: _: {}) discoveredNixFiles;
      }
    ];
  };
in
  # 4. Map the unified evaluation into the final output format
  lib.mapAttrs (name: builderScope: {
    inherit (builderScope) builderName builderOptionsSchema builderOutputModule;
  })
  evaluatedTopLevel.config.builders
