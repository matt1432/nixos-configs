pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:e3a22a791adaf8f59de605d824f8d9cf0ac7c7c779d405bb0158144e57433246";
  hash = "sha256-TMGD33oya+VQLkNLdhLUTLbWNI73JoFKs5+hy0vE3SE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
