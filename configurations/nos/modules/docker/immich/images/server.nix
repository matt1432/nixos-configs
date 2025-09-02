pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:d97aea4b3f59989a79c6adffb39a1a8b95dd27c90a7f79280b1176a6220cf17b";
  hash = "sha256-zL7nBx+g0d/MzJG+wg5qYumMWGvnlR/trcbfLjirJKs=";
  finalImageName = imageName;
  finalImageTag = "release";
}
