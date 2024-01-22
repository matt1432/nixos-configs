{
  lib,
  pkgs,
  ...
} @ inputs:
let
  inherit (lib) concatMapAttrs filterAttrs mkOption pathExists types;

  mkPackage = name: v: {
    ${name} = pkgs.callPackage ./${name} inputs;
  };

  rmNotPackage = name: value:
    value
    == "directory"
    && pathExists ./${name}/default.nix;

  packages = filterAttrs rmNotPackage (builtins.readDir ./.);

  pkgSet = concatMapAttrs mkPackage packages;
in {
  options.customPkgs = mkOption {
    type = types.attrs;
  };

  config.customPkgs = pkgSet;
}
