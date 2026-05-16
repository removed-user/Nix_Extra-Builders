# Find how to properly propogate flake inputs into each of the builder modules
{
  pkgs,
  cfg,
}: {lib, ...}: let
  # Abstract definition using standard function currying
  mkMesonPkg = attrs:
    pkgs.stdenv.mkDerivation (finalAttrs:
      {
        # Baseline defaults
        mesonBuildType = "release";

        # Core inputs that always exist
        nativeBuildInputs = [pkgs.meson pkgs.ninja];
        mesonFlags = ["-Denable-defaults=true"];
      }
      // attrs
      // {
        # Force append user items to base lists if they are supplied in attrs
        nativeBuildInputs =
          [pkgs.meson pkgs.ninja]
          ++ (attrs.nativeBuildInputs or []);

        mesonFlags =
          ["-Denable-defaults=true"]
          ++ (attrs.mesonFlags or []);
      });
in
  # Find how to make this function applicable to argument
  # Example usage
  mkMesonPkg {
    pname = "my-app";
    version = "1.0.0";
    src = ./.;
    mesonFlags = ["-Dextra-flag=true"];
  }
