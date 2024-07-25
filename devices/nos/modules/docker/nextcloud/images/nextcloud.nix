pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:ef2c7bb5acb7763d2f898214db4a65876c828aaf36567cd2ab2af6697c2f758e";
  sha256 = "08izk4al6x280bf57k0ybsdxn02w5s12qhv1avqagk4fl03lnask";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.4-fpm";
}
