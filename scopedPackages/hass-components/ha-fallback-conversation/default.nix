# FIXME: deprecated
{
  # nix build inputs
  lib,
  buildHomeAssistantComponent,
  ha-fallback-conversation-src,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  manifest = fromJSON (readFile "${ha-fallback-conversation-src}/custom_components/fallback_conversation/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "m50";

    inherit (manifest) domain version;

    src = ha-fallback-conversation-src;

    meta = {
      license = lib.licenses.mit;
      homepage = "https://github.com/m50/ha-fallback-conversation";
      description = ''
        HomeAssistant Assist Fallback Conversation Agent.
      '';
    };
  }
