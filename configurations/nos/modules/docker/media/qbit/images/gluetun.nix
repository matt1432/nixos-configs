pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:71388a455697b2cdfcbff789ba0de7be41272eebd3606373b32b0ca8647a62b3";
  hash = "sha256-e2VO6oM7GkmBbKydKwytjimGBkTT35xFgBeH5keXSeI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
