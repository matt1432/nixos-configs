{lib, pkgs, ...}: let
  mkPackage = name: v: {
    ${name} = pkgs.callPackage ./${name} {};
  };

  rmNotPackage = name: value:
    value == "directory" &&
    builtins.pathExists ./${name}/default.nix;

  packages = lib.attrsets.filterAttrs rmNotPackage (builtins.readDir ./.);

  pkgSet = lib.attrsets.concatMapAttrs mkPackage packages;
in {
  imports = [{
    options.customPkgs = lib.mkOption {
      type = lib.types.attrs;
    };
  }];

  customPkgs = pkgSet;
}
