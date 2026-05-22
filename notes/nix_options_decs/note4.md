# importer.nix
{ lib, flake-parts-lib }:
{ functionsDir, configsDir, defaultConfigFile, pkgs }:
let
  inherit (flake-parts-lib) importApply;
  
  # 1. Discover all .nix function files
  discoveredNixFiles = lib.filterAttrs 
    (fileName: fileType: fileType == "regular" && lib.hasSuffix ".nix" fileName) 
    (builtins.readDir functionsDir);

  # 2. Define the schema function. 
  # Takes the file paths via BuilderConfiguration, then returns a standard module.
  builderModuleSchema = BuilderConfiguration:
    # Natively pull 'config' from the module system's internal fixed-point.
    { config, ... }: {
      options = {
        builderName = lib.mkOption { type = lib.types.str; };
        
        builderCfg = lib.mkOption {
          type = lib.types.submodule {
            options = {
              packagePath = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
              packageArgs = lib.mkOption { type = lib.types.attrs; default = { }; };
            };
          };
        };

        builderOutputModule = lib.mkOption { type = lib.types.deferredModule; };
      };

      config = {
        # Layer the configuration options safely
        builderCfg = lib.mkMerge [
          (import defaultConfigFile)
          (if builtins.pathExists BuilderConfiguration.scopedConfigFile then import BuilderConfiguration.scopedConfigFile else { })
        ];

        # importApply binds the data into the function file
        builderOutputModule = importApply BuilderConfiguration.functionFile {
          inherit pkgs;
          cfg = config.builderCfg; # Safely references the internal module config
        };
      };
    };

in
# 3. Map over the files using mapAttrs to produce a clean Attribute Set
lib.mapAttrs (fileName: _:
  let
    cleanBuilderName = lib.removeSuffix ".nix" fileName;
    
    # Establish the unique paths for this specific iteration
    currentBuilderPaths = {
      functionFile = functionsDir + "/${fileName}";
      scopedConfigFile = configsDir + "/${cleanBuilderName}.nix";
    };
    
    # Run the isolated module evaluation engine
    isolatedEvaluation = lib.modules.evalModules {
      modules = [
        (builderModuleSchema currentBuilderPaths)
        { builderName = cleanBuilderName; }
      ];
    };
  in
  {
    # Expose unique, descriptive property names to the outer scope
    name = isolatedEvaluation.config.builderName;
    cfg = isolatedEvaluation.config.builderCfg;
    output = isolatedEvaluation.config.builderOutputModule;
    options = isolatedEvaluation.options;
  }
) discoveredNixFiles
