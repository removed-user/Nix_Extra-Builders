# modules/lib/make-builder.nix
{
  pkgs,
  cfg,
}: {lib, ...}: {
  # Register the helper function into the dendritic top-level option tree
  options.flake.lib.mkMakePkg = lib.mkOption {
    type = lib.types.raw;
    description = "Custom GNU Make package builder helper with global preset flags.";
  };

  config.flake.lib.mkMakePkg = pkgs: attrs:
    pkgs.stdenv.mkDerivation (finalAttrs:
      {
        # 1. Force strict compiler optimizations and safety flags as a baseline
        NIX_CFLAGS_COMPILE = "-O3 -Wall -Wextra " + (attrs.NIX_CFLAGS_COMPILE or "");
        NIX_LDFLAGS = "-s " + (attrs.NIX_LDFLAGS or "");

        # 2. Establish baseline make configurations
        enableParallelBuilding = true;
      }
      // attrs
      // {
        # 3. Secure core build tools and seamlessly append package-specific tools
        nativeBuildInputs =
          [pkgs.gnumake pkgs.pkg-config]
          ++ (attrs.nativeBuildInputs or []);

        # 4. Enforce standard installation paths while appending user-defined variables
        makeFlags =
          [
            "PREFIX=$(out)"
            "CC=${pkgs.stdenv.cc.targetPrefix}gcc"
          ]
          ++ (attrs.makeFlags or []);

        # 5. Handle separate build or install flags conditionally
        buildFlags = attrs.buildFlags or [];
        installFlags = ["STRIP=true"] ++ (attrs.installFlags or []);
      });
}
