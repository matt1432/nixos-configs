pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:d1c2ec5683f89f861117e4ec87f63a0ce52d431738f53c903793ef3aeef0205b";
  hash = "sha256-/JpsaY3VklssKxUw+HWm8dBEbW4VMnefivlCI2e678A=";
  finalImageName = imageName;
  finalImageTag = "14";
}
