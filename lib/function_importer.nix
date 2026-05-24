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
    ...
  }: let
    # Extract the base file name from the attribute key (e.g., "builder.nix" -> "builder")
    functionName = lib.removeSuffix ".nix" name;
    functionFile = functionsDir / "${name}";
    scopedOptionDeclsFile = OptionDeclsDir / "${functionName}.nix";
  in {
    options = {
      builderName = lib.mkOption {
        type = lib.types.str;
        default = functionName;
        description = "The name of the builder.";
      };

      builderOptionsSchema = lib.mkOption {
        description = "Merged Options Schema for this specific builder.";
        type = lib.types.submodule {
          imports =
            [
              defaultOptionDeclsFile
            ]
            ++ lib.optional (builtins.pathExists scopedOptionDeclsFile) scopedOptionDeclsFile;
        };
        default = {}; # initialize Empty
      };

      builderOutputModule = lib.mkOption {
        type = lib.types.deferredModule;
        description = "The parameterized output module generated via importApply.";
        default = importApply functionFile {
          inherit pkgs;
        };
      };
    };
  };
in {
  # 3. Export pure option declarations for the downstream module system
  options.builders = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.submodule builderSubmodule);
    default = lib.mapAttrs (fileName: _: {}) discoveredNixFiles;
    description = "Dynamically discovered and declared builder schemas.";
  };
}
