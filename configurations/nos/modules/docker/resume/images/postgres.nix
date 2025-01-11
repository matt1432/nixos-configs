pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:93a6166360be8f1d116b7ea97ebb8dea9e2c9c746349e952738bbba72a961d7c";
  hash = "sha256-jcjDWwm0HST3HSlmNxPXsewsaikvW3DA9+IAfVCpL2I=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
