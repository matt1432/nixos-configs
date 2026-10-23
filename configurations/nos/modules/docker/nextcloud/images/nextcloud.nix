pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:7c27d9b6df1413e07c94fd7ab11333cf7c4e7d5a544b1d2ec4963587df0f6da7";
  hash = "sha256-BT5DTO4GTEd8a7wKhBGrRu75k2YvUy4ASjKVhgnDbRc=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
