pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:c4772c401cf9a240ea231449e8a32585da0902dff0a7b395078428a5044dacfe";
  hash = "sha256-vLtSrO7LNrvlgmljjRVSUP1R1oEwR2jy+leODbU2l0U=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
