{
  lib,
  flake-parts-lib,
}: {
  functionsDir,
  configsDir,
  defaultConfigFile,
  pkgs,
}: let
  inherit (flake-parts-lib) importApply;

  # 1. Discover all Nix files in the directory
  discoveredNixFiles =    lib.filterAttrs    (fileName: fileType: fileType == "regular" && lib.hasSuffix ".nix" fileName)
    (builtins.readDir functionsDir);

  # 2. Define a unified schema for each builder
  builderSubmodule = {
    name,
    config,
    ...
  }: {
    options = {
      builderName = lib.mkOption {
        type = lib.types.str;
        default = name;
        description = "The name of the builder.";
      };
      builderOptionsSchema = lib.mkOption {
        type = lib.types.submodule {
          };
        };
        description = "Merged Options Schema for this specific builder.";
      };
      builderOutputModule = lib.mkOption {
        type = lib.types.deferredModule;
        description = "The parameterized output module generated via importApply.";
      };
    };

    config = let
      functionFile = functionsDir + "/${fileName}.nix";
      scopedConfigFile = configsDir + "/${name}.nix";
    in {
      # Layer configurations safely using standard module merging
      builderOptionsSchema = lib.mkMerge [
        (import defaultConfigFile)
        (
          if builtins.pathExists scopedConfigFile
          then import scopedConfigFile
          else {}
        )
      ];

      # Bind evaluated config directly into the target function file
      builderOutputModule = importApply functionFile {
        inherit pkgs;
        cfg = config.builderCfg;
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
  # 4. Map the unified evaluation into your desired final output format
  lib.mapAttrs (name: builderScope: {
    inherit (builderScope) builderName builderOptionsSchema builderOutputModule;
    options = builderScope._module.args.options;
  })
  evaluatedTopLevel.config.builders
