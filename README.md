# Example Usage

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
