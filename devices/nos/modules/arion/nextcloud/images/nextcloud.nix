pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:96299f0933835dae1c50f474d2e3d047d62886a9be0c0cb5a748d8d9af2517ac";
  sha256 = "0fwsb4ddh6bdgl0vs1ap7dvhh3yv4nqrwfcnd2sbn5rx5p73fh7g";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.0-fpm";
}
