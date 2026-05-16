# importer.nix
{ lib }:
{ functionsDir, pkgs, allConfigs }:
let
  dirContents = builtins.readDir functionsDir;
  nixFiles = lib.filterAttrs 
    (name: type: type == "regular" && lib.hasSuffix ".nix" name) 
    dirContents;
in
lib.mapAttrs' (name: _: 
  let 
    cleanName = lib.removeSuffix ".nix" name;
    filePath = functionsDir + "/${name}";
    
    fnFile = import filePath;
    locatedFnFile = lib.modules.setDefaultModuleLocation filePath fnFile;

    builderCfg = allConfigs.${cleanName} or { packagePath = null; packageArgs = { }; };
  in 
  lib.nameValuePair cleanName (locatedFnFile { inherit pkgs; cfg = builderCfg; })
) nixFiles
