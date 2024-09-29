{
  spotifyplus-src,
  buildHomeAssistantComponent,
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

    prePatch = ''
      substituteInPlace ./custom_components/spotifyplus/manifest.json \
          --replace-warn "urllib3>=1.21.1,<1.27" "urllib3>=1.21.1"
    '';

    propagatedBuildInputs = with python3Packages; [
      oauthlib
      platformdirs
      requests
      requests_oauthlib
      soco
      urllib3
      zeroconf
      smartinspect # overridden in this python3Packages
      spotifywebapi # overridden in this python3Packages
    ];
  }
