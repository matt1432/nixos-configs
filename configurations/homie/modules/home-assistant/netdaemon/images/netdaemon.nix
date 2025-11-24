pkgs: let
  inherit (import ../version.nix) majorVersion version;
in
  pkgs.dockerTools.pullImage rec {
    imageName = "ghcr.io/net-daemon/netdaemon${majorVersion}";
    imageDigest = "sha256:b151f604c3545ff4d213fd8b013614f48d6a4de807c96d38174261853fcf5467";
    hash = "sha256-TjyprorScGWpgahsuGn6HaH+Oy3DMV0XlODjDObT0ck=";
    finalImageName = imageName;
    finalImageTag = version;
  }
