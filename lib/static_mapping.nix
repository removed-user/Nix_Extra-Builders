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
  MetaPerFunction =
    lib.mapAttrs (
      fileName: _: let
        OptionDeclsDir = ./OptionsDeclarations/PerFunction;
        metaForSubModuleBuilder = {
          defaultOptionDeclsFile = ./OptionsDeclarations/AllFunctions.nix;
          perFunctionOptionDeclsFile = (toString OptionDeclsDir) + "/${fileName}";
          BuilderName = lib.removeSuffix ".nix" fileName;
        };
      in {
        # Seed values passed as an attribute set directly to the submodule generator function

        config.builders."${metaForSubModuleBuilder.BuilderName}" = {
          meta = {
            Scoped_schema = metaForSubModuleBuilder.perFunctionOptionDeclsFile;
            __file = functionsDir / "${fileName}";
          };
        };
        meta = metaForSubModuleBuilder;
      }
    )
    functionFiles;

  # 3. Submodule schema factory
  makeBuilderSubmodule = {
    meta,
    options,
    ...
  }: {
    # defaultOptionDeclsFile
    # perFunctionOptionDeclsFile
    # BuilderName
  };
  # builderOptionsSchema
in {
  # 4. Bind the default values directly to the static mapping
  options.builders = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule builderSubmodule);
    default = MetaPerFunction;
    description = "Dynamically discovered and declared builder schemas.";
  };
}
