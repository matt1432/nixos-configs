pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:b9813e15d95c172be422bf3a9ae0176cb1bf21bfb8bcf065e38dd9422fecd987";
  hash = "sha256-dZJqyKLFu5bGD4Unc5nmYwUzkosLmcGkH9tFoEJmkvE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
