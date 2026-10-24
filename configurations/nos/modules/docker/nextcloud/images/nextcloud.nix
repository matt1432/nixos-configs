pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:b69c5c73663e0c924bd634f750f960469ae2eec42972cf31c5316beb6fb5a5f5";
  hash = "sha256-GGdcVIzbMnYrEqS/GbJiE0/Q23xh7qrD7dJEopgkneo=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
