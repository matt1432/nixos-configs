pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:f25f8d61c5d3d5b963e92cfb6d53930648e995fbd22ff62d3cd8b061282f59c7";
  hash = "sha256-EwYuyw+wUhFYgwdzWBeSqwZTOdW3ugizSet6DKcvpHc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
