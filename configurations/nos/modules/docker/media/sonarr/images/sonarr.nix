pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:ca71add37a9cdbb914c7bd5b06f98bf5d2062848c8de6ac3ee09e69a4c170b27";
  hash = "sha256-07eTk1vecDzqjgUw7XCR7tAgYbT8HC10FwdPAvV7iDg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
