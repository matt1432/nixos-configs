pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:6cb678219492556a4fbf56089dddca4252e244446b008af57ddbc78d2e7e34b7";
  hash = "sha256-jpzBjD/ZDiS+FDthxrMQYtRjO1cta/8CW2Q49VJPcPM=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
