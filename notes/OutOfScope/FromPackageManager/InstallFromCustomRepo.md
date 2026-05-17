### Distribution-Specific Managers
*   **APT:** `sudo add-apt-repository ppa:user/repo && sudo apt update && sudo apt install package_name`
*   **DNF:** `sudo dnf config-manager --add-repo https://url.to && sudo dnf install package_name`
*   **Pacman:** (Add `[repo-name]\nServer = https://url.to` to `/etc/pacman.conf`), then: `sudo pacman -Sy package_name`
*   **Zypper:** `sudo zypper addrepo https://url.to repo_alias && sudo zypper refresh && sudo zypper install package_name`
*   **Portage:** `sudo eselect repository enable repo_name && sudo emaint sync -r repo_name && sudo emerge package_name`
*   **APK:** `echo "https://url.to" | sudo tee -a /etc/apk/repositories && sudo apk update && sudo apk add package_name`
*   **XBPS:** `sudo xbps-install --repository=https://url.to package_name`

### Universal Formats
*   **Flatpak:** `flatpak remote-add --if-not-exists repo_name https://url.to.flatpakrepo && flatpak install repo_name package_name`
*   **Snap:** (Snaps do not native support custom repositories; they rely entirely on the official Canonical Snap Store or local installs)
*   **AppImage:** (None, download directly from the publisher's custom website)

### Functional Managers
*   **Nix:** `nix-env -f https://github.com -iA package_name`
*   **Guix:** (Add custom channel to `~/.config/guix/channels.scm`), then: `guix pull && guix package -i package_name`

### Low-Level Frontends
*   **Dpkg / RPM:** (Low-level tools do not handle remote repositories; use APT, DNF, or Zypper instead)
