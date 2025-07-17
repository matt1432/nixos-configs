pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:de9b2e6d2c42777c009005d73462ad6d98fb22c76d90c1e93d6422938b6b6f20";
  hash = "sha256-jbOOhFxss1WSP9GsH/pVllqnP6xmTZNKx2Issmua6IA=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
