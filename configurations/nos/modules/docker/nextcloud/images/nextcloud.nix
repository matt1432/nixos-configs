pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:15ea4eaa49a0137d16c0cbf88144a8ba8e357baff4b915c0355d0c081af86560";
  hash = "sha256-ld05aAgkc6TfIZKZj72ERc0oOmXDpK9w0i8jIyM46OU=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
