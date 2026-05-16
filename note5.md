# importer.nix (Minimalist Version)
# dropped all the extra eval again, bc bloated + 
# All concerns addressed by importApply to begin with
{ lib, flake-parts-lib }:
{ functionsDir, configsDir, defaultConfigFile, pkgs }:
let
  inherit (flake-parts-lib) importApply;
  
  defaultConfig = import defaultConfigFile;
  discoveredFiles = lib.filterAttrs 
    (name: type: type == "regular" && lib.hasSuffix ".nix" name) 
    (builtins.readDir functionsDir);
in
lib.mapAttrs (fileName: _:
  let
    cleanName = lib.removeSuffix ".nix" fileName;
    functionFile = functionsDir + "/${fileName}";
    scopedConfigFile = configsDir + "/${cleanName}.nix";
    
    # Safely load the scoped config if it exists
    scopedConfig = if builtins.pathExists scopedConfigFile then import scopedConfigFile else { };
    
    # Layer the configurations together using a recursive merge (replaces mkMerge)
    mergedCfg = lib.recursiveUpdate defaultConfig scopedConfig;
  in
  {
    name = cleanName;
    cfg = mergedCfg;
    # importApply handles all the error tracing and context natively!
    output = importApply functionFile { inherit pkgs; cfg = mergedCfg; };
  }
) discoveredFiles
