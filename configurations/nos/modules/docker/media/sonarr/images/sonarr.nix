pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:889dcc58c6aea859033985894b519b2e6b1e55d92527ed123f9f52e42ae7c97b";
  hash = "sha256-aEX+KWRzuss/lg4pCyfdPDQg0Paaswvo4Ih0FvwS5sA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
