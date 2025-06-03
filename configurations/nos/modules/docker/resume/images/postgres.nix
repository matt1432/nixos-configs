pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:b86604df02ea670dcc56c4a769f283f71647e2d29c90d9edd069524ee6dcc3aa";
  hash = "sha256-eKWzAWSC+uHdLcYTupE003XtHXO67JFI8RnHAu1PbzQ=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
