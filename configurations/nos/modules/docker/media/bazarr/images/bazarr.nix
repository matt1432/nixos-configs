pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:cf7a02a46d37899eeafd1d96b81984168f771f89c554a52a2fd35437fdc16cb6";
  hash = "sha256-E3azJO/d0ORNK9J5nUu0ZzE/tUnsLntU4kssOQrLtIU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
