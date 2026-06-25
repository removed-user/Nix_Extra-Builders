{
  description = "Description for the project";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs-lib.url = "github:NixOS/nixpkgs/nixpkgs-unstable?dir=lib";

    yants.url = "github:divnix/yants";
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    # lib.url = "github:nix-community/nixpkgs.lib";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs-lib,
    yants,
    ...
  }: let
    Builders = import ./flakeModule.nix;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake.flakeModules.default = Builders;
      # systems = ["x86_64-linux"];
      perSystem = {
        # system,
        config,
        self',
        inputs',
        pkgs,
        localsystem ? "x86_64-linux",
        Builders,
        ...
      }: {
        system = localsystem;
        debug = true;
        _module.args.stdenv = pkgs.stdenv;
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}
