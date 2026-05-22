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
  in
  lib.nameValuePair cleanName locatedFnModule
) nixFiles
