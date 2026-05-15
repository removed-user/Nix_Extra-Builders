{
  perSystem = {pkgs, ...}: {
    _module.args.Builders = {
      MkMakeBuilder = import ./Builders/MkMakeBuilder.nix;
      MkMesonPkg = import ./Builders/MkMesonPkg.nix;
      MkArchive = import ./Builders/MkArchive.nix;
    };
  };
}
