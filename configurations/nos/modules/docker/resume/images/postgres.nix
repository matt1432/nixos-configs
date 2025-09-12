pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:dfcf0459185089e88a43197975780f5a3078acd5ece84824a14c9d6fbbab02d0";
  hash = "sha256-nR3KLuvCm6J0NBSJGqf9W+YZgXOr3d7939w6U4leOlg=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
