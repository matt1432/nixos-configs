pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:fb39280b7b9eba5727c884a3c7810002e69e8f961cc373b89c92f14961d903a0";
  hash = "sha256-FJ4s5hRkWmued25VmXn4pSdO8X1o/R7aY85RFwoZbiQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
