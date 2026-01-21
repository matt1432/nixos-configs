pkgs: let
  inherit (import ../version.nix) majorVersion version;
in
  pkgs.dockerTools.pullImage rec {
    imageName = "ghcr.io/net-daemon/netdaemon${majorVersion}";
    imageDigest = "sha256:6995c3788ae800d0b9255ec44dfd04f5aa4d2f264144be8e16c72677c582eeef";
    hash = "sha256-pI540MjzlXzcjLI80Vw3rb6MkLNuuH14xN4trm9gU8Y=";
    finalImageName = imageName;
    finalImageTag = version;
  }
