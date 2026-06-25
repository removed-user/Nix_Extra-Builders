# Example Usage

## Not Ready, dont use unless you want errors

Update: switched to guix, its a better language.
Not going to finish this unless nix has massive ecosystem-wide changes, adopting a bare-minimum of sanity, and making modules more reusable, generic, and lifting them out of NixOS, so nix-users in general can configure nixpkgs without Re-Authoring half the languages modules, or switching to a different OS.

In this project - 
I tried to figure out
1.the most idomatic way to auto-create options modules based on file/name mapping
2.how to write builders "entirely in lib/modules"
    - So package config could be error-checked through the module system
    - using partially applied functions
    - In order to be able to "atleast consider" **the mere concept** of ACTUALLY using functions to configure your system, instead of a bunch of hacky-options, that dont provide an interface for all compile-time options of all packages/source

Ultimately the goal was to move all the logic of the package build process into higher-order functions, where all derivation producing functions depend on an additional argument, so that a user can configure their system without the sloppy disaster of overrides.



`flake.nix`

>`Add to inputs`
```
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    
    #This input    
    Builders.url = "github:removed-user/Nix_Extra-Builders";
  };
```

>`Add to imports within mkFlake`

```
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [ inputs.Builders.flakeModule ];
    systems = [something];
```
>`expects that it inherits the pkgs argument`
```
    perSystem = { config, pkgs, ... }: {
      packages.default = config.Builders.mkMesonPkg {
        name = "my-cool-app";
        src = ./.;
        buildInputs = [ pkgs.glib ];
      };
    };
 ```
  };
}

## Functions
> MkMakeBuilder.nix
        nativeBuildInputs = [ pkgs.gnumake pkgs.pkg-config ];

> MkMesonPkg.nix
        nativeBuildInputs = [pkgs.meson pkgs.ninja];

> MkArchPkg.nix
      nativeBuildInputs = [pkgs.zstd pkgs.patchelf];

All Builders then add
          ++ (attrs.nativeBuildInputs or []);
          So you can add/append to the list within your build function
