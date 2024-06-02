pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:d2ec8002f118b22f03ed314cf866a196464ad4977142457c9401b542cf192bd7";
  sha256 = "071zynq1nsg624kk2cn9d8qicfkhwp4108q250aca7367cmax1qa";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
