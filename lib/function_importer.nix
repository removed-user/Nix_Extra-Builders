# importer.nix
{ lib, flake-parts-lib }: 
{ functionsDir, pkgs, allConfigs }:
let
  inherit (flake-parts-lib) importApply;

  dirContents = builtins.readDir functionsDir;
  nixFiles = lib.filterAttrs 
    (name: type: type == "regular" && lib.hasSuffix ".nix" name) 
    dirContents;
in
lib.mapAttrs' (name: _: 
  let 
    cleanName = lib.removeSuffix ".nix" name;
    filePath = functionsDir + "/${name}";
    
    builderCfg = allConfigs.${cleanName} or { packagePath = null; packageArgs = { }; };
  in 
  # importApply accepts the raw path directly and handles the module location tracking
  # without needing you to manually call `import` or `setDefaultModuleLocation`.
  lib.nameValuePair cleanName (importApply filePath { inherit pkgs; cfg = builderCfg; })
) nixFiles
