pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:658b40420d7a39d6eb34c797cec8d36ff315f5adb168301aaf27dc4eafc8e228";
  sha256 = "048hwc70kwmzbyqss2d8nd5y63wzzzac8m3rm7s9kblwqs9kdn5k";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.105.1";
}
