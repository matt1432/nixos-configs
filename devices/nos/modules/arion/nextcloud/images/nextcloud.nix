pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:d2dc74b2ce5fc6b06e1bf454320bb6388817757b41314a0214af4eac278a3c42";
  sha256 = "0l5325msrbgzi5zhr9yjbvpnfn8i7p4nbiigbviriq1wsl24rkmw";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.3-fpm";
}
