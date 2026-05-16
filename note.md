To shift your custom importer over to flake-parts-lib's importApply, you will change how variables from the parent file's scope are injected into the submodules. [1, 2] 
Instead of treating your .nix files as standard functions that accept an attribute set of arguments, importApply splits the file evaluation into two distinct function layers: [2, 3] 

   1. The application layer: Receives data fixed at the time of import (like pkgs and cfg).
   2. The module layer: Receives typical runtime module system arguments (like config, lib, etc.) if needed. [2, 4] 

Here is how you can update your code:
## 1. Updated importer.nix
You will pass flake-parts-lib into your importer function so that you can extract importApply. [1, 5] 

# importer.nix
{ lib, flake-parts-lib }:  # Added flake-parts-lib here
{ functionsDir, pkgs, allConfigs }:
let
  inherit (flake-parts-lib) importApply; # Extract the utility

  dirContents = builtins.readDir functionsDir;
  nixFiles = lib.filterAttrs 
    (name: type: type == "regular" && lib.hasSuffix ".nix" name) 
    dirContents;
in
lib.mapAttrs' (name: _: 
  let 
    cleanName = lib.removeSuffix ".nix" name;
    filePath = functionsDir + "/${name}";
    
    # Extract config or fall back to defaults
    builderCfg = allConfigs.${cleanName} or { packagePath = null; packageArgs = { }; };
    
    # 1. importApply wraps the file and partially applies the specified scope.
    # 2. setDefaultModuleLocation is still used to retain trace context.
    appliedFnModule = importApply filePath { inherit pkgs; cfg = builderCfg; };
    locatedFnModule = lib.modules.setDefaultModuleLocation filePath appliedFnModule;
  in 
  # Note: `locatedFnModule` is now an evaluated module payload, ready to be 
  # safely consumed by the NixOS/flake-parts module system.
  lib.nameValuePair cleanName locatedFnModule
) nixFiles

## 2. How your submodule files must change
Because importApply implements a curried two-layer function, your submodule .nix files must adapt their structure. [2, 3] 
## Before (Standard Function)
Your submodules likely look like this right now:

# functionsDir/my-helper.nix
{ pkgs, cfg }:
# Your logic returning an attribute set or a module payload
{
  # ...
}

## After (Curried for importApply)
With importApply, the arguments passed in importer.nix are received by a top-level wrapper function. The inner layer can then be a standard module system function or a static attribute set: [2, 3] 

# functionsDir/my-helper.nix

# Layer 1: Bound during import via importApply
{ pkgs, cfg }: 

# Layer 2: Standard module arguments (or an empty set if you don't use them)
{ config, lib, ... }: 

{
  # You have access to `pkgs` and `cfg` from Layer 1, 
  # as well as module system features from Layer 2.
  
  # Example output:
  options = { /* ... */ };
  config = { /* ... */ };
}

## Why make this change?

* Lexical Scope Integrity: It creates a clear boundary between the variables provided by your importer framework (pkgs, cfg) and variables natively evaluated later by the module system (config, inputs, self).
* Deferred Evaluation: It makes your generated submodules natively compatible with imports = [ ... ] arrays across flake-parts and NixOS configurations without forcing you to evaluate the functions immediately with mock args. [1, 2, 3, 6] 

Would you like assistance refactoring the flake configuration where this importer is called, or should we look at how to hook these generated modules into a flake-parts perSystem block?
