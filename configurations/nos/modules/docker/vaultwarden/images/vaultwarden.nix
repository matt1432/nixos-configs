pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:e81ca01351ecf40083366202b163e7a31abca04d96e2194e9e1f78a57052f65c";
  hash = "sha256-FpQ/yDMHUiNCpL0Fioh+PAWhZM3321q6vKS2UghvIQI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
