pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:7dfd049e79c00b16fbc29c3f5d96a9e7b9e73a23930b4c5b3c4541d60b366814";
  hash = "sha256-BxuMUpuOezxpTjbmb1yl9tph1RKKKFxfVEMbvG9YjWM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
