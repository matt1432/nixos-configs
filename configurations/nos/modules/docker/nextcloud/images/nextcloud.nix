pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:dd76149894cc80b2d55b06d9d3f79a8aacc9d5246161bdcf4e0271406af10c8e";
  hash = "sha256-t+rO/8wKu7lP5UCk/u8n+fw+R4J6kDtmy4h5qdFnQkE=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
