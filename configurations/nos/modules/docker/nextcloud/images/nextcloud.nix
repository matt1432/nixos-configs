pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:0646501a46b5b67c7f98471f5d63f1a23b0ce179d0c44fe87548f25b6e675935";
  hash = "sha256-JD1fq3XJ86xax8BFZHKnGVN2wtbh1dpvohzbwPryHag=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
