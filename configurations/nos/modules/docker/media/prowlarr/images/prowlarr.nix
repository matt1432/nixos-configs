pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:67a8aaedcfd6989f3030b937a6a07007310b1dfc7ee8df16d2cbfa48d1c1158c";
  hash = "sha256-lCeDXr9mJeBKXdo0B8/qXI0VlhTBNQhbA21W1Vvo4vM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
