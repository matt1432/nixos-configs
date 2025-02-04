pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:b2d2bc9bafb76073d96142bda07ea90c6d6afd9207fe4ff2d4f9d3b50fcdbd76";
  hash = "sha256-mFsmWV2twxnDMrWUQOSCUk5iM5N9DawcDl2iTriVgIc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
