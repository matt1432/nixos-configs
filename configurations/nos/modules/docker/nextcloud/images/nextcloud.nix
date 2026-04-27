pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:349f8d1ddf04e15fd4e854a094899511f4e1b05b8b0187d1f7173a7c41fac7cf";
  hash = "sha256-oirhqy5m7FtQcYdceGvtiHefGqwmRMeCSJH9XHore+I=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
