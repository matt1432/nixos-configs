pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:d0e57831e3d75d714bf4df155325a158adf4486856f4dbc525d5b6a702ed6fbf";
  hash = "sha256-Dx36i6mYdFR8OjcIuRi0Z9gu30ZEKxkSQkakC6UzggE=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
