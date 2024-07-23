pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:dd4306e19bb2992246f837e50541b7baf010f47954e3afcf65cafd10657f365d";
  sha256 = "08izk4al6x280bf57k0ybsdxn02w5s12qhv1avqagk4fl03lnask";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.4-fpm";
}
