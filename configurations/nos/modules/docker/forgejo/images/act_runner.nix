pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:d5ca77c6337c25ba933e568cd45412d3cd730c77e48dc07c32878250cbcbd25a";
  hash = "sha256-Q07pTTbQQPtugAOxryX6oPXf3vwEqgn3rCYPYHzJXxM=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
