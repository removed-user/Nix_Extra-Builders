# nix-template
https://github.com/jonringer/nix-template/tree/master

# nix-init

https://github.com/nix-community/nix-init


Both `nix-template` (by jonringer) and `nix-init` (from nix-community) are tools designed to scaffold Nix expressions and reduce boilerplate, but they cater to different workflows.

**`nix-init`** is generally considered the more modern, feature-rich tool for generating `default.nix` or `flake.nix` files from URLs. It is highly interactive and automatic, aimed at turning a source link into a working package.
**`nix-template`** is an older, more manual tool focused on creating standardized templates for `nixpkgs` contributions, such as `pkgs/by-name` structures.

### Comparison Table


| Feature | `nix-init` (nix-community) | `nix-template` (jonringer) |
| :--- | :--- | :--- |
| **Primary Use** | Generating packages from URLs | Scaffolding for `nixpkgs` or local devs |
| **Approach** | Automatic, interactive, AI-like | Template-based, manual input |
| **Dependency Inference** | Excellent (Rust, Go, Python) | Minimal |
| **Hash Fetching** | Automatic (via `nurl`) | Manual/Optional |
| **Nixpkgs Integration** | Low (not for direct commit) | High (knows directory structures) |
| **Best For** | Quickly packaging new software | Maintaining `nixpkgs` repository |

### Key Differences
*   **Workflow:** `nix-init` is designed for a "fetch and fix" approach. It attempts to detect the build system, infer dependencies, and fetch hashes automatically. `nix-template` requires you to know what type of expression you want (e.g., `pythonPackage`, `buildGoModule`) and helps populate the boiler-plate for that specific type.
*   **`nixpkgs` Support:** `nix-template` is tailored to help create the files needed for contributing to `nixpkgs`, including creating the necessary directory structure and advising on top-level integration.
*   **Dependency Detection:** `nix-init` excels at looking at a URL and figuring out it needs `cargoHash` or `vendorHash`, which is a major time-saver.
*   **Functionality:** `nix-init` is primarily for creating packages (`default.nix`). `nix-template` also supports creating boilerplate for NixOS modules, tests, or flakes.

### Which one should you use?
*   Use **[nix-init](https://github.com)** if you are trying to package software from GitHub, PyPI, or a URL, especially if it has a lot of dependencies.
*   Use **[nix-template](https://github.com)** if you are developing in a local environment or making a contribution to the `nixpkgs` repo and need a quick `mkDerivation` skeleton.
