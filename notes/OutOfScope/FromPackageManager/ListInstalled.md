### Distribution-Specific Managers
*   **APT:** `apt list --installed`
*   **DNF:** `dnf list installed`
*   **Pacman:** `pacman -Q`
*   **Zypper:** `zypper se --installed-only`
*   **Portage:** `qlist -I`
*   **APK:** `apk info`
*   **XBPS:** `xbps-query -l`

### Universal Formats
*   **Flatpak:** `flatpak list`
*   **Snap:** `snap list`
*   **AppImage:** (None, just list your downloaded files via `ls`)

### Functional Managers
*   **Nix:** `nix-env -q`
*   **Guix:** `guix package -I`

### Low-Level Frontends
*   **Dpkg:** `dpkg -l`
*   **RPM:** `rpm -qa`
