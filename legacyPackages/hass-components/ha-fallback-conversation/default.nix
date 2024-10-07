{
  ha-fallback-conversation-src,
  buildHomeAssistantComponent,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  manifest = fromJSON (readFile "${ha-fallback-conversation-src}/custom_components/fallback_conversation/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "m50";

    inherit (manifest) domain version;

    src = ha-fallback-conversation-src;
  }
