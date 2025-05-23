{
  # nix build inputs
  lib,
  buildHomeAssistantComponent,
  tuya-local-src,
  # deps
  tinytuya,
  tuya-device-sharing-sdk,
  ...
}: let
  inherit (builtins) fromJSON readFile;
  manifest = fromJSON (readFile "${tuya-local-src}/custom_components/tuya_local/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "make-all";

    inherit (manifest) domain version;
    src = tuya-local-src;

    dependencies = [
      tinytuya
      tuya-device-sharing-sdk
    ];

    meta = {
      license = lib.licenses.mit;
      homepage = "https://github.com/make-all/tuya-local";
      description = ''
        Local support for Tuya devices in Home Assistant.
      '';
    };
  }
