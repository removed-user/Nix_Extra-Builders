{
  perSystem = {pkgs, ...}: {
    _module.args.Builders = {

MkMakeBuilder = ./MkMakeBuilder.nix;
MkMesonPkg =    ./MkMesonPkg.nix;
    };
  };
}
