pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:dcff0b12c4b301ca85074068b262cde17888170cb7f779397e9ee07adaf0aa45";
  hash = "sha256-pX85lZ+smzInK2fmLohrHznjECI3nSoxj/sAvggFW3w=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
