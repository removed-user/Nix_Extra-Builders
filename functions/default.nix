{
  perSystem = {pkgs, ...}: {
    _module.args.Builders = {
      MkMakeBuilder = import ./MkMakeBuilder.nix;
      MkMesonPkg = import ./MkMesonPkg.nix;
      MkArchive = import ./MkArchive.nix;
    };
  };
}
