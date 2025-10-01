pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:21b6a0bf02426336f456e8dca43c55b6a79b8e01ee2c25f91bc817fc3a745e52";
  hash = "sha256-PIXu2f4/5IzFuHHj+voax5fPGxqWao5jEnAOlyX/oGQ=";
  finalImageName = imageName;
  finalImageTag = "release";
}
