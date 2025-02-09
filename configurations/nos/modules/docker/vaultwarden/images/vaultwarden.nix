pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:87edb99945da91bd7504ac1435495595af2e89ad2c7adc151ae5bf091ec8baf2";
  hash = "sha256-paMFOkR+YGL8c8tSQZMdcAS00uFrYl0xHeO/JRW6JzU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
