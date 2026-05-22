# lib/Builders_Framework.nix
{ lib, flake-parts-lib, ... }: {

  # 1. Declare the options at the top level so flake-parts can see them
  options.perSystem = lib.mkOption {
    type = lib.types.submodule ({ config, pkgs, ... }: {
      options = {
        # This will hold the final evaluated attribute set of your builders
        builders = lib.mkOption {
          type = lib.types.attrs;
          default = {};
          description = "Automatically discovered and evaluated builder functions.";
        };
      };

      # 2. Run the minimalist loop INSIDE perSystem to populate the option
      
      config.builders = let
        # Leverage the streamlined importer we designed
        importer = import ./importer.nix { inherit lib flake-parts-lib; };
      in 
        importer {
          functionsDir = ./. + "/functions";
          OptionDeclsDir = ./. + "/configs";
          defaultOptionDeclsFile = ./default-config.nix;
          inherit pkgs;
        };
    });
  };
}
