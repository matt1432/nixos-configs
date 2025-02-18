{
  # nix build inputs
  lib,
  buildHomeAssistantComponent,
  netdaemon-src,
  # deps
  python3Packages,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  manifest = fromJSON (readFile "${netdaemon-src}/custom_components/netdaemon/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "net-daemon";

    inherit (manifest) domain version;

    src = netdaemon-src;

    propagatedBuildInputs = with python3Packages; [
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
