pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:df4ae6d2bf8aa3ebd6370b42a667a007c5e7452a1cd2ab4c22fbaff9a69ffcbc";
  sha256 = "0pmx4cisxwa640ag36ls6gvasn0zg26yagp8sbr42yaaffwk9c4r";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.114.0";
}
