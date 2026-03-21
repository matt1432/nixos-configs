pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:6c76f8430d7cf043a23e1352e219d5f59dd404afa89d889cfed21c3da83501ea";
  hash = "sha256-xPGTY27+cCE56HJCwmRi37P1AgyJiyOp1Az+Pr15zZk=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
