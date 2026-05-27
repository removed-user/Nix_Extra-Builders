{
  lib,
  flake-parts-lib,
  ...
}: let
  # 1. Discover files
  functionsDir = ../Builders;
  functionFiles =
    lib.filterAttrs
    (fileName: fileType: fileType == "regular" && lib.hasSuffix ".nix" fileName)
    (lib.readDir functionsDir);

  # 2. Pre-evaluated, static metadata map
  MetaPerFunction = lib.mapAttrs (
    fileName: _: let
      OptionDeclsDir = ./OptionsDeclarations/PerFunction;
      meta = {
        defaultOptionDeclsFile = ./OptionsDeclarations/AllFunctions.nix;
        perFunctionOptionDeclsFile = (toString OptionDeclsDir) + "/${fileName}";
        BuilderName = lib.removeSuffix ".nix" fileName;
      };
    in {
      # Seed values passed as an attribute set directly to the submodule generator function
      metaForSubModuleBuilder = meta;
    }
  )
  functionFiles;

  # 3. Submodule schema factory
  makeBuilderSubmodule = {metaForSubModuleBuilder, ...}: {
    # defaultOptionDeclsFile
    # perFunctionOptionDeclsFile
    # BuilderName
  };

  builderSubmodule = {
    config,
    options,
    ...
  }: {
    # builderOptionsSchema
    options = {
      default = {...}: {
        # Safely referencing the value via the validated options/config context
        builders.${BuilderName} = {
          imports =
            [defaultOptionDeclsFile]
            ++ [scopedOptionDeclsFile];
        };
      };
    };
  };
in {
  # 4. Bind the default values directly to the static mapping
  options.builders = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule builderSubmodule);
    default = MetaPerFunction;
    description = "Dynamically discovered and declared builder schemas.";
  };
}
