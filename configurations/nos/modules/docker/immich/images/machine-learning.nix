pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:5a7bac207c5be17bbe775fdca2fef7ec6635400180ae79cc7a41659cef2c05b0";
  hash = "sha256-GH0fKdRCpKDLJGK/UUEDhp4OPQRRhkt/GZ7GhvXk9vI=";
  finalImageName = imageName;
  finalImageTag = "release";
}
