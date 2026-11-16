pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:044788f5508b7f67a3e0368cdd142c77c4d4cd5aec2efaba53e1a68b6b6231e7";
  hash = "sha256-BX7TfZHmUN0Pj7bef81ClDGkjg239YcsJvPczCyHnLw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
