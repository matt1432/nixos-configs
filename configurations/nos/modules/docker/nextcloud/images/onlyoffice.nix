pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:4b493270a8bed72bd55a81d322dc7a94ecf6b8d74df9d87b61d5a6335549d7d4";
  hash = "sha256-V7XXyzI8NIc1vLjvFiqcF8aCGnYcz0IdTcN6wwiBXmE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
