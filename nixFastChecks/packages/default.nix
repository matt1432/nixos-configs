pkgs: let
  inherit (pkgs.lib) elem filterAttrs hasAttr mapAttrs' nameValuePair;

  packages =
    filterAttrs (
      _: v:
        !(hasAttr "platforms" v.meta)
        || elem pkgs.stdenv.hostPlatform.system v.meta.platforms
    )
    pkgs.selfPackages;
in
  mapAttrs'
  (name: pkg:
    nameValuePair "pkg_${name}" pkg)
  packages
