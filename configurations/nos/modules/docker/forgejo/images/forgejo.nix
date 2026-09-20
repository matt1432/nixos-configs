pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:cf5f5ae6acf2ababca0ee3d255705b83a47f35b25e07fc931d694d60664053fe";
  hash = "sha256-P/IdoIOFQFvVatz6j9WU260kQuAefO5shZwMFsdXB2U=";
  finalImageName = imageName;
  finalImageTag = "16";
}
