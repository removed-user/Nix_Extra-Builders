> An attribute value to put in default;
> Which serves as a tag if/when you want to route a "simple" package build to the proper builder.
> Ie: The pname.nix files won't have to have full MkMesonPkg definitions, but simply - be
> an attribute set specifying the build options+buildinputs.
> A packagename.nix file with this attribute runs the default build function on the source with those values,
> While a custom-written package def overrides the default application of a builder
buildSystem = lib.mkOption {
        type = lib.types.enum [ "autotools" "cmake" "meson" "cargo" "generic" ];
        description = "The exact build system tag used to route this package";
      };
