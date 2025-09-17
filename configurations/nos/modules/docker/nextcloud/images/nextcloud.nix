pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:5e1d5f257e216882ed1800f4b426a43d8b7fddd2c3595dd08c0c248fc7873a4b";
  hash = "sha256-z1UjHDEzrYHeuWOu8CTw4B0HrODYl9hMJdh15qgPP7M=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
