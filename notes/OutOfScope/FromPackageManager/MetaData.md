### Distribution-Specific Managers
*   **APT:** Located in the `control.tar.xz` section of the `.deb`: `control` (dependencies/version), `md5sums`, `conffiles`, and maintainer scripts (`preinst`, `postinst`, `prerm`, `postrm`).
*   **DNF / Zypper:** Embedded inside the RPM file header; when built, it reads `package.spec` (defines name, version, architecture, requirements, and changelogs).
*   **Pacman:** Contained within the compressed package file: `.PKGINFO` (package variables), `.BUILDINFO` (build environment state), and `.MTREE` (file attributes/hashes).
*   **Portage:** Stored in the package directory and VDB (`/var/db/pkg`): `package-version.ebuild` (build logic), `Manifest` (file checksums), and `metadata.xml` (maintainer info).
*   **APK:** Embedded inside the package archive: `.PKGINFO` (dependencies, package size, and triggers) and `.SIGN.<keyname>.pub` (cryptographic signature block).
*   **XBPS:** Contained inside the package archive: `files.plist` (installed files manifest) and `props.plist` (package properties, dependencies, and descriptions).

### Universal Formats
*   **Flatpak:** Located inside the app's export root: `metadata` (runtime versions, sandbox permissions), along with `.desktop` files and AppStream XML components.
*   **Snap:** Located at the root of the squashfs image in a `meta/` directory: `snapcraft.yaml` (or compiled `snap.yaml`), `gui/` (icons/.desktop files), and `hooks/` (system event scripts).
*   **AppImage:** Embedded inside the root directory (`AppDir` layout): `.DirIcon`, `AppRun` (execution script), and a `<name>.desktop` file.

### Functional Managers
*   **Nix:** Found in the `/nix/store/` directory output: `manifest.nix` (or channel metadata), tracking dependencies via cross-references in the cryptographic hash path names.
*   **Guix:** Handled as pure Scheme records containing specialized metadata fields stored natively inside the local Guix transactional database.

### Low-Level Frontends
*   **Dpkg:** Stored locally in `/var/lib/dpkg/status` and `/var/lib/dpkg/info/` (contains tracking lists like `.list`, `.md5sums`, `.postinst`, and `.prerm` files).
*   **RPM:** Stored globally inside the BerkleyDB/SQLite system database at `/var/lib/rpm/` (stores files, requirements, scripts, and verification headers).
