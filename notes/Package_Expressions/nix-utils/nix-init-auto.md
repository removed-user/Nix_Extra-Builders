**`nix-init` can be completely automated** for scripts and CI/CD pipelines by utilizing its **`--headless`** flag alongside a mandatory Git URL. When run in this mode, it disables all interactive TUI prompts and relies strictly on dependency inference, default values, and your explicit command-line overrides.

### Key Automation Flags

To run `nix-init` in a non-interactive shell script, use these core options:

*   **`--headless`**: Suppresses all interactive prompts. Requires you to pass a `--url`.
*   **`-u, --url <URL>`**: Specifies the target source code URL (e.g., a GitHub repository or a tarball).
*   **`-y, --overwrite`**: Automatically overwrites existing output files without asking.
*   **`--builder <BUILDER>`**: Forces a specific ecosystem builder (e.g., `buildRustPackage`, `buildGoModule`, `buildPythonApplication`) if auto-detection isn't enough.

### Automation Example

The following script automatically creates a `default.nix` for a remote project in headless mode and overwrites any existing local file:

```bash
nix run github:nix-community/nix-init -- \
  --headless \
  --url "https://github.com" \
  --overwrite \
  ./default.nix
```

### Advanced Automation Capabilities

*   **Specify Targets**: Pin exact versions or git references using `--rev <TAG/COMMIT>` or `--version <VERSION>` to ensure reproducible generations.
*   **Ecosystem Configurations**: For Rust-based projects, pass `--cargo-vendor importCargoLock` to automate dependency lockfile setups without prompting.
*   **Git Commit Automation**: Passing `-C` or `--commit` instructs `nix-init` to automatically stage and commit the newly created files to your local repository clone.

### Global Config Files
If you repeatedly use the same package configurations (like your personal maintainer information or default license preferences), pass a file to `-c, --config <FILE>` to uniformly apply your global variables across automated batch jobs.
