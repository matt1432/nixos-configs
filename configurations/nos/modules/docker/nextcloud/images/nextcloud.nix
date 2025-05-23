pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:1c04814ce2dbcf6123bd0dca2b52c356011ea61594d21768fe07659d0e97be5a";
  hash = "sha256-DoYjlXvqf7b1Vox8Vbk+WINg727ewDdY1XV34qjuf4w=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
