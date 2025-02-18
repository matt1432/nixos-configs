{
  # nix build inputs
  lib,
  buildHomeAssistantComponent,
  spotifyplus-src,
  # deps
  python3Packages,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  manifest = fromJSON (readFile "${spotifyplus-src}/custom_components/spotifyplus/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "thlucas1";

    inherit (manifest) domain version;

    src = spotifyplus-src;

    propagatedBuildInputs = with python3Packages; [
      oauthlib
      platformdirs
      requests
      requests_oauthlib
      soco
      urllib3
      zeroconf
      smartinspect # overridden in python3Packages
      spotifywebapi # overridden in python3Packages
    ];

    meta = {
      license = lib.licenses.mit;
      homepage = "https://github.com/thlucas1/homeassistantcomponent_spotifyplus";
      description = ''
        Home Assistant integration for Spotify Player control, services,
        and soundtouchplus integration support.
      '';
    };
  }
