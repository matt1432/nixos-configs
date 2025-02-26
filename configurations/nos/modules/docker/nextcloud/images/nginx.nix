pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:9d6b58feebd2dbd3c56ab5853333d627cc6e281011cfd6050fa4bcf2072c9496";
  hash = "sha256-/njSPvscYYPeht0FKvrFlqyOeKCvlqMZjey2mm88434=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
