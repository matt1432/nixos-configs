pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:634d9a675a6fa0041062fb7dbed2a34e24bd9caed4502457c011a847fd146908";
  hash = "sha256-62p33OCkMj4aTXZi3tbgYYGc3hNXvXl3/E7y5TGA+So=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
