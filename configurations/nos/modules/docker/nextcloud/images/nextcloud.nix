pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:d6a97ab3a72b785ee3644831875ab87beabde981c19ad5dd1f088b314ac5ee38";
  hash = "sha256-bZAy8kbLASMN4Qk/EUsJz/0bWTgj5UIlTIXfMuoGgU8=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
