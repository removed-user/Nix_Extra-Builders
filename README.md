# Example Usage

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
    perSystem = { config, pkgs, ... }: {
      packages.default = config.Builders.mkMesonPkg {
        name = "my-cool-app";
        src = ./.;
        buildInputs = [ pkgs.glib ];
      };
    };
  };
}
