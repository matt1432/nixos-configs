pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:859376abea2c2fbee4cd2046cb1d9ed9714d37f200fa8b409bbca10ca3bc52e6";
  hash = "sha256-Q8s5rGQLIioWZaoF231zEYOaIKrTRSmJW254whXucBo=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
