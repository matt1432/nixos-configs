pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:733af83a24f85901232b003942a5b50820022d7429ca6569b7eecbcd6a55101a";
  hash = "sha256-m3bsnRgMoev17lPs50flcOoC8kJdi6dsXGxd/a08zz0=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
