pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/flaresolverr/flaresolverr";
  imageDigest = "sha256:139dfee1c6f89249c8d665d1333a42e8ec74ec0a86bc6bb1c8461e10d3a66a47";
  hash = "sha256-XzrFjzAeoRpmh29nIoWsUk5//dIvwAYw3UUdksBUUzM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
