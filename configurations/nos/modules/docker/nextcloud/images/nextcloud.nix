pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:4c3778f0fef290c490b1aeddeaf692d396dfbdece4082439bd8f8c13969ff084";
  hash = "sha256-3sOcqN/ka7tql8TbSyMe0TJafE2hcXfJ4+am56h+T2o=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
