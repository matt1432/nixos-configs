pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:862be1879153618f4a391b6ea0ad2943f8627fa04f2d09b2205f33ab468b548e";
  hash = "sha256-pDoloIBcRSS81D+YH431nKTv5/3xaTf6DBSS5H1xOqc=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
