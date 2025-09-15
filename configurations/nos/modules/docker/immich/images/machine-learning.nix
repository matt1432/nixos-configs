pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:5e9cc6b9717e34f3cdc591aa860d6d29c990405ef87ad057ef95f73096ae6f29";
  hash = "sha256-PAxg3ZH232YOgpsP7ivXQwt3NGFI1eBTqsx+id2xFg8=";
  finalImageName = imageName;
  finalImageTag = "release";
}
