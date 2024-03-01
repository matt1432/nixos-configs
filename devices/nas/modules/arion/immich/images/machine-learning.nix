pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:5b5c3e6bb7bcba2cb5f1e68bf504dffd9d6d05984de9d7b3f1a4c219f72441a9";
  sha256 = "1mr3scwc2khavs68ghmn3wspb6d0b51r36yb6da5wr2ndlmgkfv3";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.97.0";
}
