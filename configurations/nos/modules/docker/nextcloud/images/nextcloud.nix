pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:8f8b8be59ec86ff03b7bced861744ab715a060161f509ad9285b25e2e30610be";
  hash = "sha256-xPGTY27+cCE56HJCwmRi37P1AgyJiyOp1Az+Pr15zZk=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
