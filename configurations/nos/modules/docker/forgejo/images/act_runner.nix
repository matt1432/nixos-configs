pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:7dd9b594a79b67a9d050c953f85803e9e4c64301441ba7a742c812a37a4ec908";
  hash = "sha256-DHbCwFNKtJntR34pUFS8xsxLhKM2do2ORzqSazfABtE=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
