### Distribution-Specific Managers
*   **APT:** Extract a `.deb` archive's payload (`data.tar.xz` or `.zst` components):
    `ar x package.deb && tar -xf data.tar.*`
*   **DNF / Zypper / RPM:** Extract files from an `.rpm` archive without installing them:
    `rpm2cpio package.rpm | cpio -idmv`
*   **Pacman:** Extract an Arch package directly (it is just a standard zstd-compressed tarball):
    `tar --zstd -xf package.pkg.tar.zst`
*   **Portage:** Extract Gentoo binary package tarballs (`.tbz2` or `.xpak` formats):
    `tar -xf package.tbz2` (or use `qtbz2 -x package.tbz2` to separate metadata)
*   **APK:** Extract an Alpine Linux `.apk` package (it is internally a gzipped tarball):
    `tar -xf package.apk`
*   **XBPS:** Extract a Void Linux package archive directly (it uses xz compression):
    `tar -xf package.xbps`

### Universal Formats
*   **Flatpak:** Flatpak bundles are ostree-based or basic reference files. Extract a `.flatpak` bundle file:
    `ostree --repo=./repo bundle extract package.flatpak`
*   **Snap:** A `.snap` file is a compressed SquashFS filesystem image. Mount or unpack it directly:
    `unsquashfs package.snap`
*   **AppImage:** Unpack the bundled filesystem payload contents from the self-extracting executable:
    `./package.AppImage --appimage-extract`

### Functional Managers
*   **Nix:** Extract a compressed Nix archive closure (`.nar.xz`) back into standard directory files:
    `xz -d < file.nar.xz | nix-store --restore ./output_dir`
*   **Guix:** Guix substitutes use normalized archive (`.nar`) formatting wrapped in lzip or zstd:
    `guix archive --extract=./output_dir < package.nar`

### Low-Level Frontends
*   **Dpkg:** Extract filesystem payloads directly without dealing with the `ar` packaging tool manual steps:
    `dpkg-deb -x package.deb ./output_dir`
