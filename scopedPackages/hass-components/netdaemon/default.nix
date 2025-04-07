{
  # nix build inputs
  lib,
  buildHomeAssistantComponent,
  netdaemon-src,
  # deps
  awesomeversion,
  ...
}: let
  inherit (builtins) fromJSON readFile;
  manifest = fromJSON (readFile "${netdaemon-src}/custom_components/netdaemon/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "net-daemon";

    inherit (manifest) domain version;
    src = netdaemon-src;

    dependencies = [
      awesomeversion
    ];

    meta = {
      license = lib.licenses.mit;
      homepage = "https://github.com/net-daemon/netdaemon";
      description = ''
        An application daemon for Home Assistant written in .NET.
      '';
    };
  }
