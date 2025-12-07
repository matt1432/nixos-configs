pkgs: let
  inherit (import ../version.nix) majorVersion version;
in
  pkgs.dockerTools.pullImage rec {
    imageName = "ghcr.io/net-daemon/netdaemon${majorVersion}";
    imageDigest = "sha256:0906c7fa561db725a5e19cb7e02b00b8ade436f02e9b264e719632a7d5f41c42";
    hash = "sha256-IrJ7SgHvsbA+y95EdxoFdgyUgVO9Th+UuKtpGzLX250=";
    finalImageName = imageName;
    finalImageTag = version;
  }
