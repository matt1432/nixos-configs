pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:ad5a8edea1c25b50c6d180d35f72c1623986335113457c4ba38e1ddf16816a4b";
  sha256 = "1j3l7ap7d9a49p421i1h08bp1p772dnddijk2c8s66v3527szyp9";
  finalImageName = "ghcr.io/gethomepage/homepage";
  finalImageTag = "latest";
}
