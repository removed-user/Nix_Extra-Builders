# flakeModule.nix
{lib, ...}: let
  # Import an importer file and pass it flake-parts-lib
  loadBuilders = lib.importApply ./lib/function_importer.nix {inherit lib;};
in {
  # imports = [./config.nix];

  config.perSystem = {...}: {
    ExtraBuilders = loadBuilders {
      functionsDir = ./Builders;
      OptionDeclsDir = ./lib/OptionsDeclarations/PerFunction;
      defaultOptionDeclsFile = ./lib/OptionsDeclarations/AllFunctions.nix;
    };
  };
}
