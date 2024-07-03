pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:f22d949f5f3e16d1c3dcf0aa3ca5f7a73f053b51d2883ac864f9742d3053576b";
  sha256 = "03zcw95lhpdd0pp4zh49zpga5ir44qbq75barqgcsn8003rlzmzd";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.107.2";
}
