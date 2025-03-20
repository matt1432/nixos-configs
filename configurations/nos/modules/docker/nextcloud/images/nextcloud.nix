pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:e9470fa0b94460bfda4bb741484513fc3a5757b0b30877176c0d0e7c8727b398";
  hash = "sha256-l2ymBaZQMxgQDF8gJjvl4upFeieiKI+P00WtwT7sBZQ=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
