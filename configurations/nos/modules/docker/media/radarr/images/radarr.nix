pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:079e48870584baf2a3e7e43e7ba6d3c834555931851a59c82c51cc792d285caf";
  hash = "sha256-QS8dhz/ztPMSz4G6M4M3KRgHlSA32xI2dL7ab7y7YjU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
