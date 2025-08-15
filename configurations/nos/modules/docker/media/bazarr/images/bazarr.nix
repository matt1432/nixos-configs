pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:591793af49156dacb5f3c2a48d19e4b1522e37d16ca3aeaea0f6616f1ce7924d";
  hash = "sha256-L8QaIkd1gOcf4D/9RpaCSn25hanYVCZdf1rt9JPNKAA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
