pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:81e922037f03d40c77220d20ed73591b0ef9995638d5c68ff2c5d82ae36eea8d";
  sha256 = "17x0x19rfs69fzdqj90l35c0ifk81hrnql3lq73jakdmqr283hdz";
  finalImageName = imageName;
  finalImageTag = "latest";
}
