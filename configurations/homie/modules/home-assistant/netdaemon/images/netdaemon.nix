pkgs: let
  inherit (import ../version.nix) majorVersion version;
in
  pkgs.dockerTools.pullImage rec {
    imageName = "ghcr.io/net-daemon/netdaemon${majorVersion}";
    imageDigest = "sha256:b20ea2285243e013232bf074d6148ec93287d622d0e1aa94ef4d80af20039a1d";
    hash = "sha256-o6K5uqZykoU6lLaOjyvetj/0anfS7DaSfCWHRei3gc4=";
    finalImageName = imageName;
    finalImageTag = version;
  }
