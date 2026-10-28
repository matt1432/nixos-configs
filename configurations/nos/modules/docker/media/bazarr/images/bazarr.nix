pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:9a625883f054e722795affe5e3ca71057e6ed817ecdf99f4a99624346fcc509c";
  hash = "sha256-kDtxtl9wIbVJkqKS6RbOBU3DvHUvI3InK22+RZFwAb4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
