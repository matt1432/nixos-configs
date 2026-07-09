pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:4afbc1e6a1dfb6e7235fc5f5352a8a1a17c2a0670a6f0ec4ba20386dcfcfe2d2";
  hash = "sha256-vZLfRxxIDPziAeebf+us/GrG07gTIVOoQiVsx3s7qoQ=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
