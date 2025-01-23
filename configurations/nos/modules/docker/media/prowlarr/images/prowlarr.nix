pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:ae3abf37d442c6aed1125f7ce9d9cb7f56e64db576071f54b259da58487627a5";
  hash = "sha256-FlLfBS8JOF85MY88Z7xP6imfeO7iFsbcL23hQ2jLT3g=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
