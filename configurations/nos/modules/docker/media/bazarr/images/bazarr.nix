pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:2be164c02c0bb311b6c32e57d3d0ddc2813d524e89ab51a3408c1bf6fafecda5";
  hash = "sha256-njRe/T8RRzC+TFnOH0cMQhlKHW+wB4ugmfeYIeX3VHU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
