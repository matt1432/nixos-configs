{ fetchurl, lib, stdenv }@args:

let

  buildFirefoxXpiAddon = lib.makeOverridable ({ stdenv ? args.stdenv
    , fetchurl ? args.fetchurl, pname, version, addonId, url, sha256, meta, ...
    }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl { inherit url sha256; };

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

in packages // {
  inherit buildFirefoxXpiAddon;

  bypass-paywalls-clean = let
    version = "3.3.6.0";
  in buildFirefoxXpiAddon {
    pname = "bypass-paywalls-clean";
    inherit version;
    addonId = "magnolia@12.34";
    url =
      "https://gitlab.com/magnolia1234/bpc-uploads/-/raw/master/bypass_paywalls_clean-${version}.xpi";
    sha256 = "sha256-nuWwx7a51WI1HPkATXMLi6UZiQo+YgWWCZZk54JPDIU=";
    meta = with lib; {
      homepage = "https://gitlab.com/magnolia1234/bypass-paywalls-firefox-clean";
      description = "Bypass Paywalls of (custom) news sites";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
}
