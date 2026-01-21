pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:b03d94378104627986f7c3052c19f6b76785984b81f0312a7b06b90bb93e406c";
  hash = "sha256-5pOkKVMRlYcE/6fO5Czom1eWzbq1kuZglaa4Vf4wEVE=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
