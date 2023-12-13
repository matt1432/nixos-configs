{
  fetchurl,
  lib,
  stdenv,
} @ args: let
  buildFirefoxXpiAddon = lib.makeOverridable ({
    stdenv ? args.stdenv,
    fetchurl ? args.fetchurl,
    pname,
    version,
    addonId,
    url,
    sha256,
    meta,
    ...
  }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl {inherit url sha256;};

      preferLocalBuild = true;
      allowSubstitutes = true;

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    });

  packages = import ./generated-firefox-addons.nix {
    inherit buildFirefoxXpiAddon fetchurl lib stdenv;
  };
in
  packages
  // {
    inherit buildFirefoxXpiAddon;

    seventv = let
      version = "4.0";
    in
      buildFirefoxXpiAddon {
        pname = "frankerfacez";
        inherit version;
        addonId = "frankerfacez@frankerfacez.com";
        url = "https://cdn.frankerfacez.com/script/frankerfacez-${version}-an+fx.xpi";
        sha256 = "sha256-U/yAra2c+RlGSaQtHfBz9XYsoDaJ67gmPJBsFrpqoE8=";
        meta = with lib; {
          homepage = "https://www.frankerfacez.com/";
          description = "The Twitch Enhancement Suite. Get custom emotes and tons of new features you'll never want to go without.";
          license = licenses.asl20;
          platforms = platforms.all;
        };
      };
  }
