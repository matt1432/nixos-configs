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
      version = "v3.0.10.1000";
    in
      buildFirefoxXpiAddon {
        pname = "seventv";
        inherit version;
        addonId = "moz-addon@7tv.app";
        url = "https://extension.7tv.gg/${version}/ext.xpi";
        sha256 = "sha256-dZyjFayvnLebSZHjMTTQFjcsxxpmc1aL5q17mLF3kG8=";
        meta = with lib; {
          homepage = "https://7tv.app/";
          description = "The Web Extension for 7TV, bringing new features, emotes, vanity and performance to Twitch, Kick & YouTube";
          license = licenses.asl20;
          platforms = platforms.all;
        };
      };
  }
