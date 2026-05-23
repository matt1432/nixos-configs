pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:7a8b7b16f29d431643a038981f573ec60e2c46e115ebce5527e4320c55604af0";
  hash = "sha256-BKB3baglAFrbKkAPXM9dkxgdIgSstX7fOYT7OJpakjY=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
