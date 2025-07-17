pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:1414298ea93186123a6dcf872f778ba3bd2347edcbd2f31aa7bb2d9814ff5393";
  hash = "sha256-jbOOhFxss1WSP9GsH/pVllqnP6xmTZNKx2Issmua6IA=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
