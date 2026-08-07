pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:b44ea0478301eb84d423e1af0e79d74e146e8635665542561f13b3b1700325a9";
  hash = "sha256-nEOZRVDwBkdVmnsOTSRwY1ufBOEgWSABf87VtJXwAAI=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
