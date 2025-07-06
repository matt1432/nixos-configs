pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:b6583aeaa0fe637da09b5d8e498a3f6dcb9eef96aa59d4c455bf021c9f914119";
  hash = "sha256-Ry50m1XdAaZ71WUEj9xdP233eKEgP7DlToDX0NOmvKM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
