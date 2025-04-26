pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:a347f6c83d9d47af53819287410ac4d7f203987038bf7579d819020ef84116d3";
  hash = "sha256-iOWtDuZMvT5RG/YUnsRYuC0S4jz6SUDWyctm0RlLTVU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
