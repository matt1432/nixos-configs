pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:5e8541fc49e25c49eaedbb8fb324498a56a9cdd2761a1bfe18bcadcbcd8cf440";
  hash = "sha256-Tpq/0aNVL1IJlN78kAOJw+Q/UeDHZO4QWOJ+KQmHSmo=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
