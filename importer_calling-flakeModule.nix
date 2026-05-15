# flakeModule.nix
{ lib, config, ... }:
let
  # Import your utility file and pass it lib
  loadBuilders = import ./importer.nix { inherit lib; };
in {
  imports = [ ./config.nix ];

  config.perSystem = { pkgs, ... }: {
    ExtraBuilders = loadBuilders {
      functionsDir = ./functions;
      inherit pkgs;
      allConfigs = config.perSystem.buildersConfig;
    };
  };
}
