pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:d2b0feb698f115b6e2b93da4a0ca0bd004d47abce1eb9b716294134e3b15ef23";
  hash = "sha256-Bpq+KBMHJl+bRdU8fXs4v6RoYrwds4Z+muE85R2mSDU=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
