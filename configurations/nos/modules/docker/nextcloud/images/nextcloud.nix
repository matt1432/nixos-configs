pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:21468f5acb6d66b5abb0b78192e94a03ba1aef2ca0303f3800226363c0ee7cda";
  hash = "sha256-+0OcAbdyqCP3YT718Nr7r6EpxyrDOHGj3S6uGLI1q78=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
