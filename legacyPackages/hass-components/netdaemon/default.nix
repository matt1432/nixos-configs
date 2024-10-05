{
  netdaemon-src,
  buildHomeAssistantComponent,
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
  }
