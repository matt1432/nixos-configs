pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:fae2aafa6ecace3524fc79d102f5bfd25fb151caed6a454cee46479236ac33bf";
  hash = "sha256-fqRZg2TNXSHcxVshhqlEvZpG3dvK+jpo435YmUiRgfE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
