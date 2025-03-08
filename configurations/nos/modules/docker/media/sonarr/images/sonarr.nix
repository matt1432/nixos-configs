pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:49a8e636fd4514b23d37c84660101fecbb632174ba0569e0f09bbd2659a2a925";
  hash = "sha256-Ww7AGvfRfciiXsGswETO7E5Uv9bJ7kdkdF9VzIrIvBQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
