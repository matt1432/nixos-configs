pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:204825c8cc626a3f44fb4b61f30ca5c76c3b4c557c9fb8bfc719902bf88daae4";
  hash = "sha256-dSGCZWfxyYNSKhMmEpgpDjPpLonRDBJDxoron6/hsDg=";
  finalImageName = imageName;
  finalImageTag = "release";
}
