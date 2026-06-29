pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:66d292e5c26bd33a6f6f61cacb880de2186339a524ecba1ce098dbbaceed6515";
  hash = "sha256-2pQ+mWOQiauW0hWVlq8K/sdCXbAbP2kTO5LjIKl9yHo=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
