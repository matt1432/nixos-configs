pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:b3deefd1826f113824e9d7bc30d905e7f823535887d03f869330946b6db3b44a";
  hash = "sha256-7EwjrbAHKaMKxZo2Ji69Me6mZPVAEyND/Fog7LipoUY=";
  finalImageName = imageName;
  finalImageTag = "release";
}
