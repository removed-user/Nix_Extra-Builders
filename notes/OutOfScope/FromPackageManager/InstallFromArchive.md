### Distribution-Specific Managers
*   **APT:** `apt install ./package.deb`
*   **DNF:** `dnf install ./package.rpm`
*   **Pacman:** `pacman -U /path/to/package.pkg.tar.zst`
*   **Zypper:** `zypper install ./package.rpm`
*   **Portage:** `emerge --usepkg /path/to/package.tbz2`
*   **APK:** `apk add --allow-untrusted /path/to/package.apk`
*   **XBPS:** `xbps-install --repository=/path/to/dir package_name`

### Universal Formats
*   **Flatpak:** `flatpak install ./package.flatpak`
*   **Snap:** `snap install --dangerous ./package.snap`
*   **AppImage:** (None, just run `chmod +x package.AppImage` and `./package.AppImage`)

### Functional Managers
*   **Nix:** `nix-env -i /nix/store/...-package-name`
*   **Guix:** `guix package -f /path/to/package.scm`

### Low-Level Frontends
*   **Dpkg:** `dpkg -i package.deb`
*   **RPM:** `rpm -ivh package.rpm`
