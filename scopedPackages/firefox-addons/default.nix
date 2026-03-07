{
  fetchurl,
  lib,
  pkgs,
  stdenv,
  ...
}: let
  buildMozillaXpiAddon = lib.makeOverridable ({
    pname,
    version,
    addonId,
    url ? "",
    urls ? [], # Alternative for 'url' a list of URLs to try in specified order.
    sha256,
    meta,
    ...
  }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl {inherit url urls sha256;};

      preferLocalBuild = true;
      allowSubstitutes = true;

      passthru = {inherit addonId;};

      buildCommand =
        # bash
        ''
          dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
          mkdir -p "$dst"
          install -v -m644 "$src" "$dst/${addonId}.xpi"
        '';
    });

  packages = import ./generated-firefox-addons.nix {
    inherit buildMozillaXpiAddon fetchurl lib stdenv;
  };
in
  lib.makeScope pkgs.newScope (_: packages // {inherit buildMozillaXpiAddon;})
