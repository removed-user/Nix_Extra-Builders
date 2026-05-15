{
  perSystem = {
    lib,
    flake-parts-lib,
    ...
  }: {
    _module.args.Builders = {
      MkMakeBuilder = import ./Builders/MkMakeBuilder.nix;
      MkMesonPkg = import ./Builders/MkMesonPkg.nix;
      MkArchive = import ./Builders/MkArchive.nix;
    };
  };
}
