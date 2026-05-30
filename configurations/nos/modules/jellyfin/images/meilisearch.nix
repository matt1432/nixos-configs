pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:ac40212f9e5a7526d8007586e3e46fb0441d29dd36c7b02fa2341d2c9a1f6493";
  hash = "sha256-4qDjc3WjhCteiMWaIuCBUniPvUK32IOC8eh4bMjm5rY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
