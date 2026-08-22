pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:212b86dff59e3962b4082b5ef20a577e76c8f8527d2ab505cfa887b4bcecb0b0";
  hash = "sha256-Qn9wPYpt8bZFrgW3nky+Klnl86t/ZaVhutCQiBNtcng=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
