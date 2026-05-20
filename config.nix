{ lib, ... }: {
  options.perSystem = {
    # Allow users to point to their custom file
    packagePath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a custom packagename.nix file.";
    };
    
    # Allow passing extra custom arguments to that file if needed
    packageArgs = lib.mkOption {
      type = lib.types.attrsOf lib.types.raw;
      default = { };
      description = "Extra arguments to pass to the custom package path.";
    };

    # The final output container for your functions
    ExtraBuilders = lib.mkOption {
      type = lib.types.attrsOf lib.types.raw;
      default = {};
    };
  };
}
