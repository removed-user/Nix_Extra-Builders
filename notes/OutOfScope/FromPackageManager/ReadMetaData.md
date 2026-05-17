### Distribution-Specific Managers
*   **APT:** View metadata inside an uninstalled `.deb` archive:
    `dpkg-deb -I package.deb` (or `dpkg-deb -c package.deb` to view contained files)
*   **DNF / Zypper / RPM:** View package headers, tags, and scriptlets inside an uninstalled `.rpm`:
    `rpm -qip package.rpm` (add `--scripts` to read install/uninstall scripts)
*   **Pacman:** Read the `.PKGINFO` text data from the compressed archive payload:
    `tar -xOf package.pkg.tar.zst .PKGINFO`
*   **Portage:** Read the configuration metadata of a local binary package archive:
    `qtbz2 -t package.tbz2`
*   **APK:** View the metadata variables and dependencies inside an uninstalled Alpine `.apk`:
    `tar -xOf package.apk .PKGINFO`
*   **XBPS:** Query the internal properties and metadata plist values of an uninstalled `.xbps` file:
    `xbps-query -R --property=homepage package_name` (or unpack the `.plist` file manually)

### Universal Formats
*   **Flatpak:** Read the runtime requirements and sandbox permissions from a `.flatpak` bundle file:
    `flatpak info package.flatpak`
*   **Snap:** Inspect metadata fields, publisher details, and system hooks directly from a `.snap` file:
    `snap info ./package.snap`
*   **AppImage:** View the text inside the embedded desktop configuration file without fully unpacking:
    `./package.AppImage --appimage-extract *.desktop && cat squashfs-root/*.desktop`

### Functional Managers
*   **Nix:** Query information, inputs, and build dependencies of an uninstalled Nix archive format closure:
    `nix-store --query --references ./file.nar`
*   **Guix:** View metadata declarations by parsing the source file directly before building:
    `guix package --show=package_name`

### Low-Level Frontends
*   **Dpkg:** Handled via the same low-level tool configuration shown in the APT entry above:
    `dpkg -I package.deb`
