# nixpkgs-hammering
https://github.com/jtojnar/nixpkgs-hammering/tree/main

**Summary:**
nixpkgs-hammering is an automated linting tool that checks Nix package expressions against Nixpkgs styling guidelines and idiomatic practices. It hooks into build functions like `stdenv.mkDerivation` using custom overlays to intercept and flag common mistakes before submitting pull requests.

* **Catches Antipatterns:** Flags dangerous overrides like completely replacing `fixupPhase` instead of using targeted hooks.
* **Enforces Nixpkgs Idioms:** Points out non-idiomatic code patterns to ensure submissions match strict community maintainer standards.
* **Provides Actionable Guidance:** Links detected warnings directly to clear, official markdown explanations describing how to fix the error.
* **Performs Targeted Audits:** Analyzes only the specific package attributes you request without scanning unneeded upstream dependencies.
* **Integrates with Flakes:** Runs instantly in local workflows via `nix run github:jtojnar/nixpkgs-hammering` for seamless linting.
