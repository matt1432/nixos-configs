{
  tuya-local-src,
  buildHomeAssistantComponent,
  python3Packages,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  manifest = fromJSON (readFile "${tuya-local-src}/custom_components/tuya_local/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "make-all";

    inherit (manifest) domain version;

    src = tuya-local-src;

    propagatedBuildInputs = with python3Packages; [
      tinytuya
      tuya-device-sharing-sdk
    ];
  }
