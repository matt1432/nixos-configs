pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:fca90362ff3081fc7762d731eb24de262181eaec28afc51eff1d3ca5348663cd";
  hash = "sha256-AwbmheuzkSVBRl070NDkEOSt0VN0kwyEyywdVT6b8gw=";
  finalImageName = imageName;
  finalImageTag = "release";
}
