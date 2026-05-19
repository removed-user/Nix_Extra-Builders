https://github.com/nix-community/nix-index

**Summary:**
nix-index is a fast, offline search utility that matches files and commands to their corresponding Nix packages. It streamlines development by powering command-not-found handlers and enabling instant tool execution without prior installation.

* **Locates Missing Files:** Finds which Nix package contains a specific executable, header, or library.
* **Powers Command-Not-Found:** Suggests the correct package to install when a shell command fails.
* **Enables Instant Execution:** Acts as the backend for `comma` (`,`) to run uninstalled tools immediately.
* **Provides Offline Searching:** Uses a local database for instant query results without network lag.
* **Supports Regex Queries:** Allows advanced pattern matching to find files with partial names.

