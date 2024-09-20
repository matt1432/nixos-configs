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

    propagatedBuildInputs = with python3Packages; [
      oauthlib
      platformdirs
      requests
      requests_oauthlib
      zeroconf
      smartinspect # overridden in this python3Packages
      spotifywebapi # overridden in this python3Packages
      urllib3 # overridden in this python3Packages
    ];
  }
