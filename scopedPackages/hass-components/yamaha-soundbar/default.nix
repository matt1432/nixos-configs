{
  yamaha-soundbar-src,
  buildHomeAssistantComponent,
  python3Packages,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  manifest = fromJSON (readFile "${yamaha-soundbar-src}/custom_components/yamaha_soundbar/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "osk2";

    inherit (manifest) domain version;
    src = yamaha-soundbar-src;

    propagatedBuildInputs = with python3Packages; [
      async-upnp-client
      chardet
      validators
    ];
  }
