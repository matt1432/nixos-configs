pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:28401be15060af7f51cf8ee43002dd827899e9f4abd38e44dd59d7a7ae04dca6";
  sha256 = "1gp7yyy7rv80jcnlp5kbn55ijmbrbhcymrg5gsqnv1r70fa1pbab";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.107.0";
}
