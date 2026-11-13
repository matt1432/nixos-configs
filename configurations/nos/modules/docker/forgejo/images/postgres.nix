pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:980b7cb415aa0f812f65bdec8f6f599be408d8ed9c83ffcaa12650eac397b264";
  hash = "sha256-m1zl1kCndRn/TayS2LpXSEjUvypkcli8FVnL0qH2aKA=";
  finalImageName = imageName;
  finalImageTag = "14";
}
