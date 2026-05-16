# flakeModule.nix
{
  lib,
  config,
  ...
}: let
  # Import your utility file and pass it lib
  loadBuilders = lib.importApply ./lib/function_importer.nix {inherit lib;};
in {
  imports = [./config.nix];

  config.perSystem = {pkgs, ...}: {
    ExtraBuilders = loadBuilders {
      functionsDir = ./Builders;
      inherit pkgs;
      allConfigs = config.perSystem.buildersConfig;
    };
  };
}
