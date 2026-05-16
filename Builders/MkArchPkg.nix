{
  pkgs,
  cfg,
}: {lib, ...}: let
  # Reusable function for cross-distribution tarballs
  MkArchPkg = pkg:
    pkgs.stdenv.mkDerivation {
      name = "${pkg.pname or "package"}-${pkg.version or "output"}-generic-tar";

      # Require patchelf to strip /nix/store references from binaries
      nativeBuildInputs = [pkgs.zstd pkgs.patchelf];

      # Explicitly clear Nix-specific store tracking references
      dontDiscoverGarbageCollectionRoots = true;
      dontPatchELF = true;
      dontStrip = true;

      buildCommand = ''
        # 1. Setup isolated PKGDIR to strip Nix traces safely
        mkdir -p PKGDIR
        cp -vR ${pkg}/* PKGDIR/
        chmod -R +w PKGDIR/

        # 2. Convert hardcoded /nix/store paths to portable $ORIGIN lookups
        # Loops through all executables/libraries and strips store paths
        find PKGDIR/ -type f -exec sh -c '
          if file "$1" | grep -qE "ELF|executable|shared object"; then
            echo "Making ELF portable: $1"
            # Clear out absolute store rpaths and point to relative libs
            patchelf --set-rpath "\$ORIGIN/../lib:\$ORIGIN/lib" "$1" 2>/dev/null || true
            # Clear out hardcoded interpreter lines to use host system linker
            patchelf --remove-needed "ld-linux" "$1" 2>/dev/null || true
          fi
        ' _ {} \;

        # 3. Create clean final output directory inside the store
        mkdir -p $out

        # 4. Tar and compress the cleaned PKGDIR (purely relative files)
        # No internal symlinks will point to /nix/store
        tar -I zstd -cf $out/${pkg.pname or "archive"}.pkg.tar.zst -C PKGDIR .
      '';
    };

  # Your example package matching your parameters
  myPackage = pkgs.stdenv.mkDerivation {
    pname = "myapp";
    version = "1.0";
    src = ./.;
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/bin $out/lib
      echo 'echo "running standalone binary"' > $out/bin/myapp
      chmod +x $out/bin/myapp
    '';
  };
in
  MkArchPkg myPackage
