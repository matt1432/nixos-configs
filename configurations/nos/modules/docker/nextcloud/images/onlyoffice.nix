pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:34b92f4a67bfd939bd6b75893e8217556e3b977f81e49472f7e28737b741ba1d";
  hash = "sha256-fng7EFO7c/llpC+hBSoWiOLm7KEUAPMKI6Jd8EaUvfk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
