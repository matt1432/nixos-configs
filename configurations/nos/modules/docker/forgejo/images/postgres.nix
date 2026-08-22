pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:2fdfb9b432d4a73bd3eea3d989752c1e669b68d502347e0bfd2cc6d709f3d6b4";
  hash = "sha256-d6gsL9Ecv02VUFU5bWr7oE9EPaHjzAQ+7AtjCFPIebg=";
  finalImageName = imageName;
  finalImageTag = "14";
}
