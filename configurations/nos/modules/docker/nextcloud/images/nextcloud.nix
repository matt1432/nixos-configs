pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:a04e3bb8df30769a5edbb01434893d3873a11e6e42a53b984c06e27944a014c2";
  hash = "sha256-0204pLQ2d6s7UqL6fQeCq+jnAkD47hzp2BJ0w0r6e8w=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
