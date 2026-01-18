pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:65e461d78206659b0bd6b4159075bebbd15dcb7d891980131b23dcdabd2e899c";
  hash = "sha256-5pOkKVMRlYcE/6fO5Czom1eWzbq1kuZglaa4Vf4wEVE=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
