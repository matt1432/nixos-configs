pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:71996384718e0033764bf90dad0ef271537dd3213df2fe51fc71816cf3ae74ae";
  hash = "sha256-3jET/h6hW+FnANr9xIQg/AIhpK8rM8dDAdxY+0doYp4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
