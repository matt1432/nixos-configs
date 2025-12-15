pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:2614292ecd488d0b2eda86f83ca07c7b29ae417f0b7cd5cd121eec0b044f721b";
  hash = "sha256-VDvkniuOOKtxNwLtuUF+AWI9af8Hv+THxiyxU8P77es=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
