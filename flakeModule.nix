# flakeModule.nix
{
  lib,
  config,
  ...
}: let
  # Import an importer file and pass it flake-pkgs-lib
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
