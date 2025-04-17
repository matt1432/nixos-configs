pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:0daa2d1d414d49286bfa9495fc0c936e7e73edaf8944a61102a7a6353a952297";
  hash = "sha256-HO2z4wjDWYTUWaOtrbPC0+XsxMMU/fBDykava6KVLiY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
