pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:946dc8c5bb5331418eac60050cf40a63cb8f66ac039841dda493870e3559799c";
  hash = "sha256-KfLhepB4g2y9QvQw+iCJbK/eQe1AgfmfQeuM89dPwFw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
