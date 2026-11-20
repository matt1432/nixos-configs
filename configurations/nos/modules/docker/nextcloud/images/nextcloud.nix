pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:6f973a6d4347b2418620738e288d9bd91294875665106106ac36ee04b4a64e30";
  hash = "sha256-PyEaZ3aTdFJTgAImpT0zbOjcg0falnRINoHWbI2QUZI=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
